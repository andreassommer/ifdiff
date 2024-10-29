function [ifhead, rIndex_ifbody] = replaceJumpifByCtrlif_parseJumpSpec(mtreeobj, jumpifNode, jumpSpec)
%REPLACEJUMPIFBYCTRLIF_PARSEJUMPSPEC check a jump specification's format and return some important row indices into it
% a jump specification has the form:
%
% if ifdiff_jumpif(<switchingFunction>, <direction>)
%     ... statements ...
%     ifdiff_update(<update>);
% end
%
% which means "if the expression <switchingFunction> crosses zero in direction <direction>, increment the
% state by the update <update>".
% We refer to the body of the if block as "update block". <update> should be C1, although IFDIFF does not enforce this.
% During preprocessing, the above is replaced by (roughly, a few params are omitted here):
%
% ctrlif(<switchingFunction> >= 0, ..., <ctrlif_index>, ...)
% if ctrljump(<ctrlif_index>, <direction>)
%     ... statements ...
%     ifdiff_update(<update>);
% end
%
% Now, the ctrlif can monitor our switching function. And once it has switched, the ctrljump, which is linked to the
% ctrlif through the ctrlif_index, can be used to identify which particular state jump should be applied.
%
% args:
%   mtreeobj: mtree of the (preprocessed) RHS
%   jumpifNode: the row index of the jump specifier function
%   jumpSpec: the identifier of the function that signals the jump. As you see in the above code examples, it is either
%       ifdiff_jumpif or ctrljump. It would probably have been prettier for this function to have a flag argument
%       "isPreprocessed" instead. But since we return an rIndex, and every function using it will need to have
%       the appropriate identifier in scope anyway, it seemed more sensible to just take the identifier as a parameter.
% return:
%   ifhead: the row index of the IFHEAD node that precedes the jumpif
%   rIndex_body: the rIndex of the update block. the exact indices of the ifdiff_update node(s) can be directly
%       read from there.
% throw an exception if the format of the jump specification is not as described above
    config = makeConfig();
    cIndex = mtree_cIndex();
    update = config.jump.updateFunction;

    ifhead = mtree_findBeginOfLine(mtreeobj, jumpifNode, mtreeobj.K.IFHEAD);
    rIndex_ifhead = mtree_rIndex(subtree(select(mtreeobj, mtreeobj.T(ifhead, cIndex.indexLeftchild))));

    if ~isfield(rIndex_ifhead.BODY, jumpSpec)
        throw(badFormatException([jumpSpec ' is not in the head of an if statement']));
    elseif length(rIndex_ifhead.BODY.(jumpSpec)) > 1
        throw(badFormatException(['multiple instances of ' jumpSpec ' in one if head']));
    elseif length(rIndex_ifhead.BODY.([jumpSpec '_Arg'])) ~= 2
        throw(badFormatException(['# of arguments to ' jumpSpec ' is not 2']));
    elseif isfield(rIndex_ifhead.BODY, update)
        throw(badFormatException([update ' appears in the if head']));
    end

    rIndex_ifbody = mtree_rIndex(subtree(select(mtreeobj, ifhead)));
    if ~isfield(rIndex_ifbody.BODY, update)
        throw(badFormatException(['no update specified (no uses of ' update ')']));
    end
    
    function e = badFormatException(message)
        specFormatMessage = join([ ...
            'a jump specification has the form: ', ...
            'if ifdiff_jumpif(<switchingFunction>, <direction>)', ...
            '    ...', ...
            '    ifdiff_update(<update>);', ...
            'end', ...
            '    ', ...
            'meaning ''when the expression <switchingFunction> crosses zero in direction <direction>, ', ...
            'apply the update given by the expression <update>''. ', ...
            '', ...
            'Error: ', ...
            char(message);
            ], newline);
        e = MException("preprocess:badJumpSpecification", specFormatMessage);
    end
end
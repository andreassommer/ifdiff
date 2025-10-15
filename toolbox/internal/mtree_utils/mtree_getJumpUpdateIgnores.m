function nodeIndices = mtree_getJumpUpdateIgnores(mtreeobj)
%MTREE_GETJUMPUPDATEIGNORES Get the row indices of all if, max, abs, etc. inside jump update blocks
% A jump's update expression should be C1 and there should not be any nondifferentiabilities inside the update block.
% We do not want to force this on the user, however. You might want to have a conditional debug statement in there
% or something. Preprocessing them would also cause problems, however, so we have to skip them. This function
% finds the nondifferentiabilities' indices so they can be skipped during preprocessing.
    config = makeConfig();
    rIndex = mtree_rIndex(mtreeobj);
    cIndex = mtree_cIndex();
    jumpSpec = config.jump.specifyingFunction;

    nodeIndices = [];
    % check if there are any jumps specified in mtreeobj. if not, we are done
    if ~isfield(rIndex.BODY, jumpSpec)
        % nothing to do
        return
    end

    jumpNodes    = rIndex.BODY.(jumpSpec);

    for i=1:length(jumpNodes)
        [ifhead, jumpRIndex] = replaceJumpifByCtrlif_parseJumpSpec(mtreeobj, jumpNodes(i), jumpSpec);
        ifNode = mtreeobj.T(ifhead, cIndex.indexParentNode);
        body = jumpRIndex.BODY;

        ifs  = getOrDefault(body, 'IF', []);
        iifs = getOrDefault(body, 'Iif', []);
        abs  = getOrDefault(body, 'abs', []);
        max  = getOrDefault(body, 'max', []);
        min  = getOrDefault(body, 'min', []);
        sign  = getOrDefault(body, 'sign', []);

        % find all function calls
        mtreeobj_if = Tree(select(mtreeobj, ifhead));
        calls = find(mtfind(mtreeobj_if, 'Kind', 'CALL').IX);
        functions = mtreeobj_if.T(calls, cIndex.indexLeftchild)';

        nodeIndices = [nodeIndices ifNode ifs iifs abs max min sign functions];
    end
end
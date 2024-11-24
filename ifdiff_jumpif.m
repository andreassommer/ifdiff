function shouldIJumpRightNow = ifdiff_jumpif(switchingFunction, direction)
% Use this function in a RHS to signal that the state should jump when the value `switchingFunction` hits zero.
% direction can be -1, 0, or 1, determining whether to jump when the state goes from negative to positive (1),
% positive to negative (-1), or both (0).% a jump specification has the form:
%
% if ifdiff_jumpif(<switchingFunction>, <direction>)
%     ... statements ...
%     ifdiff_update(<update>);
% end
%
% which means "if the expression <switchingFunction> crosses zero in direction <direction>, increment the
% state by the update <update>".
% We refer to the body of the if block as "update block". <update> should be C1, although IFDIFF does not enforce this.
%
% In order to actually execute the update, IFDIFF first constructs a jump function and then executes that. Meaning,
% in ordinary integration, ifdiff_jumpif just returns false to minimize unnecessary computations.
    shouldIJumpRightNow = false;
end
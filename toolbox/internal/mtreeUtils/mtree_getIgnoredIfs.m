function nodeIndices = mtree_getIgnoredIfs(mtreeobj)
%MTREE_GETIGNOREDIFS Get the row indices of all nodes in an mtree that are if statements that should be ignored
% If an if block has an ignore string (config.preprocess_ignorestring) after the condition, that if statement
% and all if statements within its bodies are added to the list.
    rIndex = mtree_rIndex(mtreeobj);
    cIndex = mtree_cIndex();

    nodeIndices = [];
    if ~isfield(rIndex.BODY, 'IF')
        % nothing to do
        return
    end

    for i = 1:length(rIndex.BODY.IF)
        ifIndex = rIndex.BODY.IF(i);
        selected = select(mtreeobj, ifIndex);
        if mtree_ifnode_has_ifdiff_ignore(selected)
            nodeIndices(end+1) = ifIndex;

            % search in the if body and every elseif/else body for more if nodes and add these to the list
            bodyIndex = mtreeobj.T(ifIndex, cIndex.indexLeftchild);
            while bodyIndex ~= 0
                bodySubtree = Tree(select(mtreeobj, mtreeobj.T(bodyIndex, cIndex.indexRightchild)));
                subtreeRIndex = mtree_rIndex(bodySubtree);

                ifs  = getOrDefault(subtreeRIndex.BODY, 'IF', []);
                iifs = getOrDefault(subtreeRIndex.BODY, 'Iif', []);
                abs  = getOrDefault(subtreeRIndex.BODY, 'abs', []);
                max  = getOrDefault(subtreeRIndex.BODY, 'max', []);
                min  = getOrDefault(subtreeRIndex.BODY, 'min', []);
                sign  = getOrDefault(subtreeRIndex.BODY, 'sign', []);

                % find all function calls
                ifSubtree = Tree(select(mtreeobj, bodyIndex));
                calls = find(mtfind(ifSubtree, 'Kind', 'CALL').IX);
                functions = ifSubtree.T(calls, cIndex.indexLeftchild)';

                nodeIndices = [nodeIndices ifs iifs abs max min sign functions];
                bodyIndex = mtreeobj.T(bodyIndex, cIndex.indexNextNode);
            end
        end
    end
end
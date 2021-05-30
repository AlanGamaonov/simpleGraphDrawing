function DrawGraph(pathToFile)

    % Матрица смежности
    A = zeros(1, 1);

    fileExtention = extractAfter(pathToFile, '.');
    if strcmp(fileExtention, 'txt')
        A = readFromEdgesList(pathToFile);
    elseif strcmp(fileExtention, 'mtx')
        A = mmread(pathToFile);
        A(A ~= 0) = 1;
    else
        error('Unknown file extention! Use .txt or .mtx')
    end
    
    draw(A)
    
    function A = readFromEdgesList(path)
        source = fopen(path);
        rawEdges = textscan(source, '%d %d');
        fclose(source);
    
        edges = [rawEdges{1} rawEdges{2}];
        N = max(max(rawEdges{1}), max(rawEdges{2})) + 1;
        A = zeros(N, N);
    
        for edgeNum = 1:length(edges)
            i = edges(edgeNum, 1) + 1;
            j = edges(edgeNum, 2) + 1;
            A(i, j) = 1;
            A(j, i) = 1;
        end
    end
    
    function draw(A)
        D = diag(sum(A));
        K = D - A;
        [v, ~] = eigs(K, 3, 'sm');
        gplot(A, v(:, [2 3]))
        hold on
        gplot(A, v(:, [2 3]), 'o')
    end

end
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
        [v, e] = eigs(K, length(A));
        e = round(e);
        
        min = realmax;
        ri = 0; rj = 0;
        for i=1:length(e)
            for j=1:length(e)
                if (i ~= j & e(i, i) * e(j, j) ~= 0)
                    XY = v(:, [i j]);
                    s = 0;
                    for fv=1:length(XY)
                        for sv=1:length(XY)
                            if (fv ~= sv & A(fv, sv) ~= 0)
                                s = s + (XY(fv,1) - XY(sv,1))^2 + (XY(fv,2) - XY(sv,2))^2;
                            end
                        end
                    end
                    if (s < min)
                        min = s;
                        ri = i; rj = j;
                    end
                end
            end
        end
        
        gplot(A, v(:, [ri rj]))
        hold on
        gplot(A, v(:, [ri rj]), 'o')
    end

end
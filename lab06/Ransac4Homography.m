function finalH = Ransac4Homography(matches1, matches2)
% macthes are 2*N size matrixes matching with each other

if ~isequal(size(matches1), size(matches2))
    error('Points matrices different sizes');
end
if size(matches1, 1) ~= 2
    error('Points matrices must have two rows');
end
n = size(matches1, 2);
if n < 4
    error('Need at least 4 matching points');
end

% Using SVD
x = matches2(1, :); y = matches2(2,:); 
X = matches1(1,:); Y = matches1(2,:);

rows0 = zeros(3, n);
rowsXY = -[X; Y; ones(1,n)];

hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];

if n == 4
    [U, ~, ~] = svd(h);
else
    [U, ~, ~] = svd(h, 'econ');
end
finalH = (reshape(U(:,9), 3, 3)).';
end
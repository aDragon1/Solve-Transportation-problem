function fval = solveTP(C, supply, needs)

% Преобразуем векторы запасов и потребностей в матрицы с единственным столбцом
supply = supply(:);
needs = needs(:);

[m, n] = size(C);

if m ~= numel(supply) || n ~= numel(needs)
    error('Размерности матрицы затрат, вектора запасов и вектора потребностей не совпадают.');
end

% Переписываем задачу в форму линейного программирования
f = reshape(C.', [], 1); % Векторизация матрицы затрат

% Матрица ограничений для запасов (supply)
A_supply = kron(eye(m), ones(1, n));
b_supply = supply;

% Матрица ограничений для потребностей (needs)
A_needs = kron(ones(1, m), eye(n));
b_needs = needs;

% Объединяем все ограничения
A = [A_supply; A_needs];
b = [b_supply; b_needs];

% Ограничения переменных: все перевозки должны быть неотрицательными
lb = zeros(m * n, 1);
ub = [];

% Решаем задачу линейного программирования
options = optimoptions('linprog', 'Display', 'none', 'Algorithm', 'dual-simplex'); % Отключаем вывод
[X_vector, fval, exitflag, ~] = linprog(f, [], [], A, b, lb, ub, [], options);

% Проверяем, что решение было найдено
if exitflag ~= 1
    error('Решение не найдено. Код завершения: %d', exitflag);
end

% Преобразуем решение обратно в матрицу
X = reshape(X_vector, [n, m]).';
end

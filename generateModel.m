function [C, supply, needs] = generateModel(n)
% Генерация случайной таблицы стоимостей
C = randi([10, 200], n, n);

% Генерация случайных запасов и потребностей
supply = randi([50, 100], 1, n);
needs = randi([50, 100], 1, n);

% Сбалансируем запасы и потребности
total_supply = sum(supply);
total_demand = sum(needs);

if total_supply > total_demand
    % Увеличим потребности
    needs(n) = needs(n) + (total_supply - total_demand);
else
    % Увеличим запасы
    supply(n) = supply(n) + (total_demand - total_supply);
end
end
function [cost, stepsCount] = norhWestMethod(C, supply, needs)

if sum(supply) ~= sum(needs) % Проверка на закрытость
    error('Сумма запасов и потребностей должна совпадать.');
end

[n, ~] = size(C);
X = zeros(n, n);

supplyCopy = supply; % Копия массива для изменения
needsCopy = needs; % Копия массива для изменения

stepsCount = 0;
i = 1; % Итератор по supply
j = 1; % Итератор по needs
while any(supplyCopy > 0) && any(needsCopy > 0)
    stepsCount = stepsCount + 1;
    amount = min(supplyCopy(i), needsCopy(j));

    X(i, j) = amount; % Заполнение результирующей таблицы

    supplyCopy(i) = supplyCopy(i) - amount; % Уменьшение запасов
    needsCopy(j) = needsCopy(j) - amount;   % Уменьшение потребностей

    if needsCopy(j) == 0
        j = j + 1;
    elseif  supplyCopy(i) == 0
        i = i + 1;
    end
end
cost = sum(sum(X .* C));
end
function [cost, stepCount] = minRateMethod(C, supply, needs)
if sum(supply) ~= sum(needs) % Проверка на закрытость
    error('Сумма запасов и потребностей должна совпадать.');
end

[m, n] = size(C);
X = zeros(m, n);

% Копия массивов для изменения
CCopy = C;
supplyCopy = supply;
needsCopy = needs;

stepCount = 1;
while any(supplyCopy > 0) && any(needsCopy > 0) % Пока в запасах или в потребностях есть не нулевое значение
    % Найти индекс минимального элемента в C
    [~, idx] = min(CCopy(:)); % Двумерный массив С в одномерный и найти индекс минимального значения
    [i, j] = ind2sub(size(CCopy), idx); % Одномерный индекс в индексы двумерного массива

    amount = min(supplyCopy(i), needsCopy(j)); % Количество для распределения


    X(i, j) = amount; % Заполнение результирующей таблицы

    % Уменьшение запасов и потребностей
    supplyCopy(i) = supplyCopy(i) - amount;
    needsCopy(j) = needsCopy(j) - amount;

    % Удаление распределенного элемента, чтобы не выбирать его снова
    if supplyCopy(i) == 0
        CCopy(i, :) = inf; % Заменить строку на бесконечности
    end
    if needsCopy(j) == 0
        CCopy(:, j) = inf; % Заменить столбец на бесконечности
    end
    stepCount = stepCount + 1;
end

cost = sum(sum(X .* C));
end

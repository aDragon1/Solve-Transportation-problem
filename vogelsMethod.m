function [cost, stepCount] = vogelsMethod(C, supply, needs)
if sum(supply) ~= sum(needs) % Проверка на закрытость
    error('Сумма запасов и потребностей должна совпадать.');
end

[m, n] = size(C);
X = zeros(m, n);

supplyCopy = supply; % Копия массива для изменения
needsCopy = needs; % Копия массива для изменения

stepCount = 1;
while any(supplyCopy > 0) && any(needsCopy > 0) % Пока в запасах или в потребностях есть не нулевое значение
    row_penalties = calculateRowPenalties(C, supplyCopy, needsCopy); % разности в строках
    col_penalties = calculateColPenalties(C, supplyCopy, needsCopy); % разности в столбцах

    [max_row_penalty, row_idx] = max(row_penalties); % максимальная разность в строке
    [max_col_penalty, col_idx] = max(col_penalties); % максимальная разность в столбце

    if max_row_penalty >= max_col_penalty % Если разница в строке больше, чем в столбце
        i = row_idx; % Сохраняем индекс
        valid_cols = find(needsCopy > 0); % Находим не нулевые потребности
        [~, min_col_idx] = min(C(i, valid_cols)); % Ищем минимальный подходящий элемент
        j = valid_cols(min_col_idx); % Сохраняем второй индекс
    else
        j = col_idx;
        valid_rows = find(supplyCopy > 0);
        [~, min_row_idx] = min(C(valid_rows, j));
        i = valid_rows(min_row_idx);
    end

    amount = min(supplyCopy(i), needsCopy(j)); % Считаем минимум из потребностей и запасов на пересечении i,j
    X(i, j) = amount; % Сохраняем в результирующий массив значение
    supplyCopy(i) = supplyCopy(i) - amount;
    needsCopy(j) = needsCopy(j) - amount;
    stepCount = stepCount + 1;
end
cost = sum(sum(X .* C));
end

function row_penalties = calculateRowPenalties(C, s, d)
% Количество строк (источников)
m = size(C, 1);
% Инициализация штрафов для строк
row_penalties = -Inf(m, 1);
for i = 1:m
    if s(i) > 0
        row_costs = C(i, d > 0);
        row_costs_sorted = sort(row_costs);
        if numel(row_costs_sorted) > 1
            row_penalties(i) = row_costs_sorted(2) - row_costs_sorted(1);
        else
            row_penalties(i) = row_costs_sorted(1);
        end
    end
end
end

function col_penalties = calculateColPenalties(C, s, d)
% Количество столбцов (пунктов назначения)
n = size(C, 2);
% Инициализация штрафов для столбцов
col_penalties = -Inf(1, n);
for j = 1:n
    if d(j) > 0
        col_costs = C(s > 0, j);
        col_costs_sorted = sort(col_costs);
        if numel(col_costs_sorted) > 1
            col_penalties(j) = col_costs_sorted(2) - col_costs_sorted(1);
        else
            col_penalties(j) = col_costs_sorted(1);
        end
    end
end
end
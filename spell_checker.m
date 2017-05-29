function spell_checker()
    load('dictionary.mat', 'dict');
    %ƴд����������򣬿������У��޷���ֵ
    while 1
        try
            how_many = input('����Ҫ���ٸ����鵥�ʣ�');
            if (rem(how_many, 1) == 0) && (how_many > 0)
                break;
            else
                disp('��������������');
            end
        catch
            disp('���������֣�');
            continue;
        end
    end 
    while 1
        the_object = input('������һ������(��<Ctrl+C>������)��', 's');
        if sum(ismember(dict, the_object)) == 1
            disp('��������');
            fprintf('\n');
            continue;
        else
            for e = [1:length(dict)]
                compare_dic(e).word = dict{e};
                compare_dic(e).distance = cul_distance(dict{e}, the_object);
            end
            compare_dic_mid = {compare_dic.word; compare_dic.distance}.';
            [~, order] = sortrows(compare_dic_mid, 2);
            total = min(how_many, length(order));
            disp('������ĵ��ʲ����ֵ��У������ԣ�');
            disp('0.  �������������롿');
            disp('1.  �����õ���������ֵ䡿');
            for r = [1:total]
                disp([num2str(r+1), '.  ���滻Ϊ��', compare_dic(order(r)).word]);
            end
            while 1
                try
                    option = input('��ϣ����');
                    if (option-1 > total) || (option < 0)
                        disp('����ֵ���ڷ�Χ��');
                        continue;
                    elseif rem(option, 1) ~= 0
                        disp('������������');
                        continue;
                    else
                        break;
                    end
                catch
                    disp('���������֣�');
                    continue;
                end
            end
            switch option
                case 0
                    fprintf('\n');
                    continue;
                case 1
                    dict = [dict.', the_object].';
                    save('dictionary.mat', 'dict');
                    disp('��ӳɹ�!');
                    fprintf('\n');
                    continue;
                otherwise
                    try
                       disp(['�滻�ɹ���', compare_dic(order(option-1)).word]);
                       fprintf('\n');
                    catch
                        disp('δ֪ԭ��ʧ�ܣ����������뵥�ʣ�');
                        continue;
                    end
            end               
        end
    end
end

function DL_distance = cul_distance(a, b)
    DL_distance = cul_distance_mid(a, b, length(a), length(b));
end

function DL_distance_mid = cul_distance_mid(a, b, i, j)
    if min(i, j) == 0
        DL_distance_mid = max(i, j);
    elseif (i > 1) && (j > 1) && (a(i) == b(j - 1)) && (a(i - 1) == b(j))
        DL_distance_mid = min([...
            cul_distance_mid(a, b, i - 1, j) + 1, ...
            cul_distance_mid(a, b, i, j - 1) + 1, ...
            cul_distance_mid(a, b, i - 1, j - 1) + double(a(i) ~= b(j)), ...
            cul_distance_mid(a, b, i - 2, j - 2) + 1, ...
            ]);
    else
        DL_distance_mid = min([...
            cul_distance_mid(a, b, i - 1, j) + 1, ...
            cul_distance_mid(a, b, i, j - 1) + 1, ...
            cul_distance_mid(a, b, i - 1, j - 1) + double(a(i) ~= b(j)), ...
            ]);
    end
end
function spell_checker()
    load('dictionary.mat', 'dict');
    %拼写检查器主程序，控制运行，无返回值
    while 1
        try
            how_many = input('您需要多少个建议单词？');
            if (rem(how_many, 1) == 0) && (how_many > 0)
                break;
            else
                disp('请输入正整数！');
            end
        catch
            disp('请输入数字！');
            continue;
        end
    end 
    while 1
        the_object = input('请输入一个单词(按<Ctrl+C>结束。)：', 's');
        if sum(ismember(dict, the_object)) == 1
            disp('单词无误！');
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
            disp('您输入的单词不在字典中！您可以：');
            disp('0.  【返回重新输入】');
            disp('1.  【将该单词添加至字典】');
            for r = [1:total]
                disp([num2str(r+1), '.  【替换为】', compare_dic(order(r)).word]);
            end
            while 1
                try
                    option = input('您希望：');
                    if (option-1 > total) || (option < 0)
                        disp('输入值不在范围！');
                        continue;
                    elseif rem(option, 1) ~= 0
                        disp('请输入整数！');
                        continue;
                    else
                        break;
                    end
                catch
                    disp('请输入数字！');
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
                    disp('添加成功!');
                    fprintf('\n');
                    continue;
                otherwise
                    try
                       disp(['替换成功！', compare_dic(order(option-1)).word]);
                       fprintf('\n');
                    catch
                        disp('未知原因失败！请重新输入单词！');
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
function LabM4_TTT

    clear;
    clc;
    global btn_array
    turn = 0;
    Xscore = 0;
    Oscore = 0;
    Tscore = 0;
    gameover = false;
    x_win_message = 'X is the winner! Play again?';
    o_win_message = 'O is the winner! Play again?';
    draw_message = 'Nobody wins! Play again?';
    m = [0 0 0; 0 0 0; 0 0 0];
        
    Nrows = 3;
    Ncols = 3;
    
    ph = uipanel;
    ph.Position = [15, 15, 70, 70]/100;
    
    
    for i = 1:Nrows
        for j = 1:Ncols
            w = 1/Ncols;
            h = 1/Nrows;
            x = (j-1)*w;
            y = (i-1)*h;
            btn_array{i, j} = uicontrol;
            btn_array{i, j}.Parent = ph;
            btn_array{i, j}.Units = 'normalized';
            btn_array{i, j}.FontSize = 64;
            btn_array{i, j}.Position = [x y w h];
            btn_array{i, j}.BackgroundColor = [0.5 1 0.8];
            btn_array{i, j}.Callback = {@button_update, i, j};
        end
    end
    
    abt_btn = uicontrol();
    abt_btn.String = 'ABOUT';
    abt_btn.Units = 'normalized';
    abt_btn.Position = [0.1 0.05 0.09 0.05];
    abt_btn.Callback = 'msgbox(''Author: Tommy Golbranson'', ''About'')';
    
    quit_btn = uicontrol;
    quit_btn.Units = 'normalized';
    quit_btn.Position = [0.81 0.05 0.09 0.05];
    quit_btn.Callback = 'close';
    quit_btn.String = 'QUIT';

    reset = uicontrol;
    reset.Units = 'normalized';
    reset.Position = [0.2 0.05 0.09 0.05];
    reset.Callback = 'LabM4_TTT';
    reset.String = 'RESET';
    
    bot1 = uicontrol;
    bot1.Units = 'normalized';
    bot1.Position = [0.315 0.05 0.19 0.08];
    bot1.Callback = @randbot;
    bot1.BackgroundColor = [1 .5 1];
    bot1.String = 'RANDOM MOVE';
    
    bot2 = uicontrol;
    bot2.Units = 'normalized';
    bot2.Position = [0.515 0.05 0.19 0.08];
    bot2.Callback = @smartbot;
    bot2.BackgroundColor = [1 .5 1];
    bot2.String = 'SMART MOVE';
    
    
    title = uicontrol;
    title.Style = 'text';
    title.FontSize = 48;
    title.ForegroundColor = [1 .5 1];
    title.Units = 'normalized';
    title.Position = [0.265 0.85 0.5 0.15];
    title.String = 'Tic Tac Toe!';
    
    x_win_label = uicontrol;
    x_win_label.Style = 'text';
    x_win_label.FontSize = 12;
    x_win_label.BackgroundColor = [.8 .8 .8];
    x_win_label.Units = 'normalized';
    x_win_label.Position = [0.025 0.7 0.1 0.05];
    x_win_label.String = 'X Wins';
    
    x_win_count = uicontrol;
    x_win_count.Style = 'text';
    x_win_count.FontSize = 28;
    x_win_count.Units = 'normalized';
    x_win_count.Position = [0.025 0.62 0.1 0.07];
    x_win_count.String = Xscore;
    
    
    
    o_win_label = uicontrol;
    o_win_label.Style = 'text';
    o_win_label.FontSize = 12;
    o_win_label.BackgroundColor = [.8 .8 .8];
    o_win_label.Units = 'normalized';
    o_win_label.Position = [0.025 0.5 0.1 0.05];
    o_win_label.String = 'O Wins';
    
    o_win_count = uicontrol;
    o_win_count.Style = 'text';
    o_win_count.FontSize = 28;
    o_win_count.Units = 'normalized';
    o_win_count.Position = [0.025 0.42 0.1 0.07];
    o_win_count.String = Oscore;
    
    
    
    draw_label = uicontrol;
    draw_label.Style = 'text';
    draw_label.FontSize = 12;
    draw_label.BackgroundColor = [.8 .8 .8];
    draw_label.Units = 'normalized';
    draw_label.Position = [0.025 0.3 0.1 0.05];
    draw_label.String = 'Draws';
    
    draw_count = uicontrol;
    draw_count.Style = 'text';
    draw_count.FontSize = 28;
    draw_count.Units = 'normalized';
    draw_count.Position = [0.025 0.22 0.1 0.07];
    draw_count.String = Tscore;
    
%%
    function button_update(~, ~, row, col)
        gameover = false;
        btn_array{row, col}.Enable = 'inactive';
        turn = turn+1;

        if (rem(turn, 2) == 1)
            btn_array{row, col}.String = 'X';
            m(row, col) = 1;
        else
            btn_array{row, col}.String = 'O';
            m(row, col) = 5;
        end
        check4end();
    end
%%
    function randbot(~, ~)
        done = false;
        while (done==false && turn<9 && gameover==false)
            row = randi(3);
            col = randi(3);
            
            if (m(row, col)==0 && gameover==false)
                btn_array{row, col}.Enable = 'inactive';
                if (rem(turn, 2) == 0)
                    btn_array{row, col}.String = 'X';
                    m(row, col) = 1;
                else
                    btn_array{row, col}.String = 'O';
                    m(row, col) = 5;
                end
                turn = turn+1;
                check4end();
                done = true;
            end
        end
    end
%%
    function smartbot(~, ~)
        flipped = fliplr(m);
        
        if (turn<9 && gameover == false)
            if (sum(m(1,:)) == 2 || sum(m(1,:)) == 10) 
                choose_from_row(1);
            elseif (sum(m(2,:)) == 2 || sum(m(2,:)) == 10)
                choose_from_row(2);
            elseif (sum(m(3,:)) == 2 || sum(m(3,:)) == 10)
                choose_from_row(3);
            elseif (sum(m(:,1)) == 2 || sum(m(:,1)) == 10)
                choose_from_col(1);
            elseif (sum(m(:,2)) == 2 || sum(m(:,2)) == 10)
                choose_from_col(2);
            elseif (sum(m(:,3)) == 2 || sum(m(:,3)) == 10)
                choose_from_col(3);
            elseif (sum(diag(m)) == 2 || sum(diag(m)) == 10)
                choose_from_diag;
            elseif (sum(diag(flipped)) == 2 || sum(diag(flipped)) == 10)
                choose_from_fliplr_diag;
            else
                randbot;
            end
        else
            endgame(draw_message);
        end
%%        
        function choose_from_row(row)
            c = find(m(row, :) == 0);
            if (rem(turn, 2) == 0)
                btn_array{row, c}.String = 'X';
                m(row, c) = 1;
            else
                btn_array{row, c}.String = 'O';
                m(row, c) = 5;
            end
            btn_array{row, c}.Enable = 'inactive';
            turn = turn+1;
            check4end;
        end
        
        function choose_from_col(col)
            r = find(m(:, col) == 0);
            if (rem(turn, 2) == 0)
                btn_array{r, col}.String = 'X';
                m(r, col) = 1;
            else
                btn_array{r, col}.String = 'O';
                m(r, col) = 5;
            end
            btn_array{r, col}.Enable = 'inactive';
            turn = turn+1;
            check4end;
        end
 %%       
        function choose_from_diag
            if (strcmp(btn_array{1, 1}.Enable, 'on'))
                if (rem(turn, 2) == 0)
                    btn_array{1, 1}.String = 'X';
                    m(1, 1) = 1;
                else
                    btn_array{1, 1}.String = 'O';
                    m(1, 1) = 5;
                end
                btn_array{1, 1}.Enable = 'inactive';
            elseif (strcmp(btn_array{2, 2}.Enable, 'on'))
                if (rem(turn, 2) == 0)
                    btn_array{2, 2}.String = 'X';
                    m(2, 2) = 1;
                else
                    btn_array{2, 2}.String = 'O';
                    m(2, 2) = 5;
                end
                btn_array{2, 2}.Enable = 'inactive';
            elseif (strcmp(btn_array{3, 3}.Enable, 'on'))
                if (rem(turn, 2) == 0)
                    btn_array{3, 3}.String = 'X';
                    m(3, 3) = 1;
                else
                    btn_array{3, 3}.String = 'O';
                    m(3, 3) = 5;
                end
                btn_array{3, 3}.Enable = 'inactive';
            end
            
            turn = turn+1;
            check4end;
        end
            
        function choose_from_fliplr_diag
            if (strcmp(btn_array{1, 3}.Enable, 'on'))
                if (rem(turn, 2) == 0)
                    btn_array{1, 3}.String = 'X';
                    m(1, 3) = 1;
                else
                    btn_array{1, 3}.String = 'O';
                    m(1, 3) = 5;
                end
                btn_array{1, 3}.Enable = 'inactive';
            elseif (strcmp(btn_array{2, 2}.Enable, 'on'))
                if (rem(turn, 2) == 0)
                    btn_array{2, 2}.String = 'X';
                    m(2, 2) = 1;
                else
                    btn_array{2, 2}.String = 'O';
                    m(2, 2) = 5;
                end
                btn_array{2, 2}.Enable = 'inactive';
            elseif (strcmp(btn_array{3, 1}.Enable, 'on'))
                if (rem(turn, 2) == 0)
                    btn_array{3, 1}.String = 'X';
                    m(3, 1) = 1;
                else
                    btn_array{3, 1}.String = 'O';
                    m(3, 1) = 5;
                end
                btn_array{3, 1}.Enable = 'inactive';
            end
            turn = turn+1;
            check4end;
        end
    end


%%
    function check4end
        flipped = fliplr(m);
        
        if (sum(m(1,:)) == 3) 
            endgame(x_win_message);
        elseif (sum(m(2,:)) == 3)
            endgame(x_win_message);
        elseif (sum(m(3,:)) == 3)
            endgame(x_win_message);
        elseif (sum(m(:,1)) == 3)
            endgame(x_win_message);
        elseif (sum(m(:,2)) == 3)
            endgame(x_win_message);
        elseif (sum(m(:,3)) == 3)
            endgame(x_win_message);
        elseif (sum(diag(m)) == 3)
            endgame(x_win_message);
        elseif (sum(diag(flipped)) == 3)
            endgame(x_win_message);
        end
        
        if (sum(m(1,:)) == 15) 
            endgame(o_win_message);
        elseif (sum(m(2,:)) == 15)
            endgame(o_win_message);
        elseif (sum(m(3,:)) == 15)
            endgame(o_win_message);
        elseif (sum(m(:,1)) == 15)
            endgame(o_win_message);
        elseif (sum(m(:,2)) == 15)
            endgame(o_win_message);
        elseif (sum(m(:,3)) == 15)
            endgame(o_win_message);
        elseif (sum(diag(m)) == 15)
            endgame(o_win_message);
        elseif (sum(diag(flipped)) == 15)
             endgame(o_win_message);
        end
        
        if (turn == 9 && gameover == false)
            endgame(draw_message);
        end
    end

%%
    function endgame(winner)
        turn = -1;
        gameover = true;
        if (strcmp(winner, o_win_message))
            Oscore = Oscore + 1;
            o_win_count.String = Oscore;
        elseif (strcmp(winner, x_win_message))
            Xscore = Xscore + 1;
            x_win_count.String = Xscore;
        else 
            Tscore = Tscore + 1;
            draw_count.String = Tscore;
        end
        answer = questdlg(winner);

        if (strcmp(answer, 'Yes'))
            newgame;
        else
            close;
        end
    end

%%
    function newgame
        gameover = false;
        turn = 0;
        m = [0 0 0; 0 0 0; 0 0 0];
        for row = 1:3
            for col = 1:3
                btn_array{row, col}.Enable = 'on';
                btn_array{row, col}.String = '';
            end
        end
    end
end
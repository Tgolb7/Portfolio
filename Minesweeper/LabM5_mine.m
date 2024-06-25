function LabM5_mine

    clear;
    clc;
    global btn_array;
    gameover = false;
        
    ph = uipanel;
    ph.Position = [15, 15, 70, 70]/100;
    
    turn = 0;
    Nrows = 10;
    Ncols = 10;
    Nmines = 15;
    count = 0;
    m = zeros(Nrows, Ncols);
    t = zeros(Nrows, Ncols);
    neighbor_sum = 0;
    surnum = 0;
    
    gridsize = inputdlg({'Rows (5-15 recommended)', 'Columns (5-15 recommended)', 'Mines (Should be less than rows*columns)'},'Enter a grid size', [1 45], {'10', '10', '15'});
    
    Nrows = str2num(gridsize{1});
    Ncols = str2num(gridsize{2});
    Nmines = str2num(gridsize{3});
    m = zeros(Nrows, Ncols);
    t = zeros(Nrows, Ncols);
    
    
    title = uicontrol;
    title.Style = 'text';
    title.FontSize = 32;
    title.ForegroundColor = [1 .5 1];
    title.Units = 'normalized';
    title.Position = [0.25 0.85 0.5 0.15];
    title.String = 'MINESWEEPER';
    
    
    bottom = uicontrol;
    bottom.Style = 'text';
    bottom.FontSize = 18;
    bottom.Units = 'normalized';
    bottom.String = 'Probability:';
    bottom.Position = [0.32 0.05 0.35 0.07];
    
    prob = uicontrol;
    prob.Style = 'text';
    prob.FontSize = 18;
    prob.Units = 'normalized';
    prob.String = ' : ';
    prob.Position = [0.58 0.05 0.07 0.07];
    
    abt_btn = uicontrol();
    abt_btn.String = 'ABOUT';
    abt_btn.Units = 'normalized';
    abt_btn.Position = [0.1 0.05 0.09 0.05];
    abt_btn.Callback = 'msgbox({''- Click on a button to reveal either a mine or a number.''; ''- If you click on a mine, the game ends.'';''- Numbers reveal how many mines are in the 8 surrounding buttons.''; ''- Probability expresses the number of mines in the surrounding unclicked cells.''; ''- Activating the "FLAG" button will allow you to mark cells that may be mines''; ''- Created by Tommy Golbranson, 2021''}, ''About'')';

    reset = uicontrol;
    reset.Units = 'normalized';
    reset.Position = [0.2 0.05 0.09 0.05];
    reset.Callback = 'LabM5_mine';
    reset.String = 'RESET';
    
    hint = uicontrol;
    hint.Units = 'normalized';
    hint.Position = [0.3 0.05 0.09 0.05];
    hint.Callback = @use_hint;
    hint.String = 'HINT';
    
    flagbtn = uicontrol;
    flagbtn.Units = 'normalized';
    flagbtn.Position = [0.02 0.05 0.08 0.08];
    flagbtn.BackgroundColor = [.6 .6 .6];
    flagbtn.Callback = @flag;
    flagbtn.String = 'FLAG';

    reveal = uicontrol;
    reveal.Units = 'normalized';
    reveal.Position = [0.7 0.05 0.09 0.05];
    reveal.Callback = @reveal_mines;
    reveal.String = 'REVEAL';
    
    quit_btn = uicontrol;
    quit_btn.Units = 'normalized';
    quit_btn.Position = [0.8 0.05 0.09 0.05];
    quit_btn.Callback = 'close';
    quit_btn.String = 'QUIT';    
    
    for i = 1:Nrows
        for j = 1:Ncols
            w = 1/Ncols;
            h = 1/Nrows;
            x = (j-1)*w;
            y = (i-1)*h;
            btn_array{i, j} = uicontrol;
            btn_array{i, j}.Parent = ph;
            btn_array{i, j}.Units = 'normalized';
            btn_array{i, j}.FontSize = 240/Nrows;
            btn_array{i, j}.Position = [x y w h];
            btn_array{i, j}.BackgroundColor = [.7 .7 .7];
            btn_array{i, j}.Callback = {@button_update, i, j};
        end
    end

    mines_layed = 0;
    while(mines_layed < Nmines)
        randX = randi(Nrows);
        randY = randi(Ncols);
        if (m(randX, randY) == 0)
            m(randX, randY) = 1;
            mines_layed = mines_layed+1;
        end
    end
    
    
    function button_update(~, ~, row, col)
        if (gameover == false)
            if (mod(count, 2)==1)
                %btn_array{row, col}.Enable = 'inactive';
                btn_array{row, col}.String = '#';
                return;
            end
            turn = turn + 1;
            btn_array{row, col}.Enable = 'inactive';
            btn_array{row, col}.BackgroundColor = [1 1 1];
            neighbor_sum=0;
            if (m(row, col) == 1) %if a mine is selected
                btn_array{row, col}.BackgroundColor = [1 0 0];
                btn_array{row, col}.String = 'X';
                endgame;
                return;
            end
            t(row, col) = 1;
            if(row~=1 && col~=1 && row~=Nrows && col~=Ncols && m(row, col)==0) %if a non-edge button is selected
                for g=(row-1):(row+1)
                    for d = (col-1):(col+1)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;
                
            elseif (row==1 && col==1)
                neighbor_sum = 0;
                for g=(row):(row+1)
                    for d = (col):(col+1)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;
            elseif(row==Nrows && col==1)
                for g=(row-1):(row)
                    for d = (col):(col+1)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;

            elseif(row==1 && col==Ncols)
                for g=(row):(row+1)
                    for d = (col-1):(col)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;   

            elseif(row==Nrows && col==Ncols)
                for g=(row-1):(row)
                    for d = (col-1):(col)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;

            elseif(row==1)
                for g=(row):(row+1)
                    for d = (col-1):(col+1)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;

            elseif(row==Nrows)
                for g=(row-1):(row)
                    for d = (col-1):(col+1)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;

            elseif(col==1)
                for g=(row-1):(row+1)
                    for d = (col):(col+1)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;

            elseif(col==Ncols)
                for g=(row-1):(row+1)
                    for d = (col-1):(col)
                        neighbor_sum = neighbor_sum + m(g,d);
                    end
                end
                btn_array{row, col}.String = neighbor_sum;
            end
        end
        calcprob(row, col);
        if (gameover == false && turn == (Nrows*Ncols)-Nmines)
            win;
        end
    end

    
    function reveal_mines(~, ~)
        reveal.Enable = 'inactive';
        for r=1:Nrows
            for c=1:Ncols
                if(m(r,c) == 1)
                    btn_array{r, c}.String = '-';
                end
            end
        end
    end

    function use_hint(~, ~)
        hinted = false;
        while(hinted == false && gameover==false && turn < ((Nrows*Ncols)-Nmines)) 
            hintX = randi(Nrows);
            hintY = randi(Ncols);
            if(m(hintX, hintY) == 0 && strcmp(btn_array{hintX, hintY}.Enable, 'on')==true)
                button_update(0, 0, hintX, hintY);
                hinted = true;
            end
        end
    end


    function calcprob(row, col)
        revealed_sum = 0;
        if(row~=1 && col~=1 && row~=Nrows && col~=Ncols && m(row, col)==0)
            surnum=8;
            for g=(row-1):(row+1)
                for d = (col-1):(col+1)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif (row==1 && col==1)
            revealed_sum = 0;
            surnum=3;
            for g=(row):(row+1)
                for d = (col):(col+1)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end
            
        elseif(row==Nrows && col==1)
            surnum=3;
            for g=(row-1):(row)
                for d = (col):(col+1)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif(row==1 && col==Ncols)
            surnum=3;
            for g=(row):(row+1)
                for d = (col-1):(col)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif(row==Nrows && col==Ncols)
            surnum=3;
            for g=(row-1):(row)
                for d = (col-1):(col)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif(row==1)
            surnum=5;
            for g=(row):(row+1)
                for d = (col-1):(col+1)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif(row==Nrows)
            surnum=5;
            for g=(row-1):(row)
                for d = (col-1):(col+1)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif(col==1)
            surnum=5;
            for g=(row-1):(row+1)
                for d = (col):(col+1)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end

        elseif(col==Ncols)
            surnum=5;
            for g=(row-1):(row+1)
                for d = (col-1):(col)
                    revealed_sum = revealed_sum + t(g,d);
                end
            end
        end
        prob.String = [num2str(neighbor_sum) ':' num2str((surnum-revealed_sum)+1)];
    end

    function endgame
        gameover = true;
        reveal.Enable = 'inactive';
        bottom.String = 'GAME OVER';
        bottom.Position = [0.35 0.05 0.35 0.07];

        prob.Visible = 'off';
        for p = 1:Nrows
            for q = 1:Ncols
                btn_array{p,q}.Enable = 'off';
                if (m(p, q) == 1)
                    btn_array{p,q}.BackgroundColor = [1, 0 0];
                    btn_array{p,q}.String = 'X';
                end
            end
        end
    end

    function flag (~, ~)
        if (rem(count, 2) == 1)
            flagbtn.BackgroundColor = [.6 .6 .6];
        elseif (rem(count, 2) == 0)
            flagbtn.BackgroundColor = [.2 1 .2];
        end
        count = count+1;
    end

    function win
        answer = questdlg('You win! Play again?');
        if (strcmp(answer, 'Yes'))
            LabM5_mine;
        else
            close;
        end
    end
end
function [BestX,BestF] = BWOFdb(egitim,test,komsu,fdbCase)
    Npop=50;
    pb=55;
    maxFE=100*pb;
    lb=0;
    ub=1;
    


    fit = inf*ones(Npop,1);
    newfit = fit;
    FE=0;

    pos = rand(Npop,pb).*(ub-lb)+lb;

    for i = 1:Npop
        fit(i,1) = agirlikli_knn(pos(i,:),egitim,test,komsu);
        FE = FE+1;
    end

    [BestF,index]=min(fit);
    BestX = pos(index,:);

    while FE < maxFE

        newpos = pos;
        WF = 0.1-0.05*(FE/maxFE);  
        kk = (1-0.5*FE/maxFE)*rand(Npop,1); 
        for i = 1:Npop
            if kk(i) > 0.5 
                r1 = rand(); 
                r2 = rand();
                if (fdbCase == 1)
                    RJ=rouletteFitnessDistanceBalance(pos,fit);
                    while RJ == i
                        RJ = ceil(Npop*rand);
                    end 
                else
                    RJ = ceil(Npop*rand);   % Roulette Wheel Selection
                    while RJ == i
                        RJ = ceil(Npop*rand);
                    end    
                end

                if rand<rand 
                    params = randperm(pb,2);
                    newpos(i,params(1)) = pos(i,params(1))+(pos(RJ,params(1))-pos(i,params(2)))*(r1+1)*sin(r2*2*pi);
                    newpos(i,params(2)) = pos(i,params(2))+(pos(RJ,params(1))-pos(i,params(2)))*(r1+1)*cos(r2*2*pi);
                else
                    params=randperm(pb);
                    for j = 1:floor(pb/2)
                        newpos(i,2*j-1) = pos(i,params(2*j-1))+(pos(RJ,params(1))-pos(i,params(2*j-1)))*(r1+1)*sin(r2*2*pi);
                        newpos(i,2*j) = pos(i,params(2*j))+(pos(RJ,params(1))-pos(i,params(2*j)))*(r1+1)*cos(r2*2*pi);
                    end
                end
            else  % exploitation phase
                r3 = rand(); 
                r4 = rand(); 
                C1 = 2*r4*(1-FE/maxFE);
                if (fdbCase == 2) 
                    RJ=rouletteFitnessDistanceBalance(pos,fit);
                    while RJ == i
                        RJ = ceil(Npop*rand);
                    end 
                else
                    RJ = ceil(Npop*rand);   % Roulette Wheel Selection
                    while RJ == i
                        RJ = ceil(Npop*rand);
                    end    
                end

                alpha=3/2;
                sigma=(gamma(1+alpha)*sin(pi*alpha/2)/(gamma((1+alpha)/2)*alpha*2^((alpha-1)/2)))^(1/alpha); 
                u=randn(1,pb).*sigma;
                v=randn(1,pb);
                S=u./abs(v).^(1/alpha);
                KD = 0.05;
                LevyFlight=KD.*S;
                newpos(i,:) = r3*BestX - r4*pos(i,:) + C1*LevyFlight.*(pos(RJ,:)-pos(i,:));
            end

            % boundary
            Flag4ub = newpos(i,:)>ub;
            Flag4lb = newpos(i,:)<lb;
            newpos(i,:)=(newpos(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
            newfit(i,1) =  agirlikli_knn(pos(i,:),egitim,test,komsu);   
            FE = FE+1;
            if newfit(i,1) < fit(i,1)
                pos(i,:) = newpos(i,:);
                fit(i,1) = newfit(i,1);
            end 
            if fit(i)<BestF
               BestF=fit(i);
               BestX=pos(i,:);
            end        
        end

        for i = 1:Npop
            % whale falls
            if kk(i) <= WF

                if (fdbCase == 3) 
                    RJ=rouletteFitnessDistanceBalance(pos,fit);
                else
                    RJ = ceil(Npop*rand);   % Roulette Wheel Selection
                end

                r5 = rand(); 
                r6 = rand(); 
                r7 = rand();
                C2 = 2*Npop*WF;
                stepsize2 = r7*(ub-lb)*exp(-C2*FE/maxFE);
                newpos(i,:) = (r5*pos(i,:) - r6*pos(RJ,:)) + stepsize2;
                % boundary
                Flag4ub = newpos(i,:)>ub;
                Flag4lb = newpos(i,:)<lb;
                newpos(i,:)=(newpos(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
                newfit(i,1) =  agirlikli_knn(pos(i,:),egitim,test,komsu);   % fitness calculation
                FE = FE+1;
                if newfit(i,1) < fit(i,1)
                    pos(i,:) = newpos(i,:);
                    fit(i,1) = newfit(i,1);
                end
                if fit(i)<BestF
                   BestF=fit(i);
                   BestX=pos(i,:); 
                end  
            end
        end

        [fval,index]=min(fit);
        if fval<BestF
            BestF = fval;
            BestX = pos(index,:);
        end
    end

       % fprintf('%d \n',BestF);
       % fprintf('%d \n',BestX);
end
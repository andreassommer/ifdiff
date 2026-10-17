function dx = swbRHS(~,x,p)
    dx = zeros(3,1);
    dx(1) = x(2); % sinus
    dx(2) = -x(1); % cosinus
   
    % eps repariert den Fehler
    % => Vergleich von x(1) mit p=0 ist das Problem
    % da x(1)=sin(0)=0 bei t=0 gilt sowohl x(1)<= -p als auch x(1) >= - p
    % -0.0 und 0.0 verschieden?
    % => x(1) <= p
    % Da x(2)=cos(0)=1 > 0 => geht in else dx(3)=1

    % Fix
    %eps = 1e-20;
    if x(1) <= -p %+ eps % Bedingung 1
        if x(1) <= p %+ eps % diese Bedingung ist immer wahr, wenn
        %Bedingung 1 wahr und p pos.
            if x(2) < 0
                dx(3) = -1;
            else
                dx(3) = 1;
            end
       end
    end
end
function output = assembleSensitivityOutput(sensData, Gmatrices_intermediate, t_sort_unique, Gy_flag, Gp_flag, Gmatrices_intermediate_flag)
   % output = assembleSensitivityOutput(sensData, Gmatrices_intermediate, t_sort_unique, Gy_flag, Gp_flag, Gmatrices_intermediate_flag)
   %
   % Assembles the struct that contains the relevant information of the sensitivities and intermediates for the user.
   %
   % INPUT: sensData                    - struct array that contains the timepoints, the modelNum and the sensitivities at the 
   %                                      given timepoints w.r.t. y0 and p
   %        Gmatrices_intermediate      - struct that contains the intermediates and updates w.r.t. y0 and p
   %        t_sort_unique               - sorted vector of the timepoints and which the sensitivities have been calculated
   %        Gy_flag                     - flag that is true if the sensitivities w.r.t. the initial values have been calculated
   %        Gp_flag                     - flag that is true if the sensitivities w.r.t. the parameters have been calculated
   %        Gmatrices_intermediate_flag - flag if the intermediates and updates should be included in the output for the user
   %
   % OUTPUT: output - struct that contains the sensitivity information assembled as requested from the user.
   
   fieldnames = {'t', 'Gy', 'Gy_intermediate', 'Uy', 'Gp', 'Gp_intermediate', 'Up'};
   output = generateStructArray(fieldnames, length(t_sort_unique));
   
   % sensData is a struct array that has the length of the number of models being activated during the calculations.
   % If an entry is empty, it means that no timepoint for calculations was given in the time interval of that respective model. 
   
   count = 1;
   for i = 1 : size(sensData, 2)
      
      if isempty(sensData(i).timepoints)
         continue
      end
      
      modelNum = sensData(i).modelNum;
      
      for k = 1 : length(sensData(i).timepoints)
         
         output(count).t = sensData(i).timepoints(k);
         
         if Gy_flag
            output(count).Gy = sensData(i).Gy{k};
            if Gmatrices_intermediate_flag
               output(count).Gy_intermediate = Gmatrices_intermediate.Gy(2:modelNum);
               output(count).Uy = Gmatrices_intermediate.Uy(2:modelNum);
            end
         end
         
         if Gp_flag
            output(count).Gp = sensData(i).Gp{k};
            if Gmatrices_intermediate_flag
               output(count).Gp_intermediate = Gmatrices_intermediate.Gp(2:modelNum);
               output(count).Up = Gmatrices_intermediate.Up(2:modelNum);
            end
         end
         
         count = count + 1;
      end
   end
end
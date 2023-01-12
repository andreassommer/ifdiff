function times = getTimes(umax)
% get precomputed times for control switches as struct
% depending on umax

if (umax==2)

   t0 = 0;
   t1 = 0.074140;
   t2 = 0.0820268;
   t3 = 0.101444;
   t4 = 0.110420;
   tf = 0.111184;
   times = struct('t0',t0,'t1',t1,'t2',t2,'t3',t3,'t4',t4,'tf',tf);
   
elseif (umax==3)

   t0  = 0;
   t1  = 0.0416854; 
   tv1 = 0.04800526;
   t2  = 0.0525894;
   tv2 = 0.05635593;
   t3  = 0.0786491;
   t4  = 0.0878590;
   tf  = 0.0886180;
   times = struct('t0',t0,'t1',t1,'t2',t2,'t3',t3,'t4',t4,'tf',tf,'tv1',tv1,'tv2',tv2);
   
end
   


end
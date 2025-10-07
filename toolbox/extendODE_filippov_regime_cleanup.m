function sliding = extendODE_filippov_regime_cleanup(sliding)
% Clean up the fields in sliding after integration in Filippov mode.
sliding.filippov_rhs   = [];
sliding.alpha_last     = [];
sliding.index          = [];
sliding.ctrlif_index   = [];
sliding.function_index = [];

end
function ifdiff_keepvar(varargin)
%IFDIFF_KEEPVAR: prevents all passed variables from being deleted during
%function-optimization in deleteUnusedParameters.m. Place this function
%after the last initialization of the corresponding variables and before
%the first switch (if, abs, min, max, ...) it is used in for correct 
%behaviour. Usually the line after the last initialization is a safe place!
%If you need to keep several initializations over consecutive switches
%ifdiff_keepvar needs to be used before each one!
%
% INPUT:
%   varargin - all variables that may not be deleted
end


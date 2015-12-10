%%
% pass variable by reference
% from http://stackoverflow.com/questions/14793453/matlab-link-to-variable-not-variable-value
classdef RefValue < handle
    properties
        data = [];
    end
end
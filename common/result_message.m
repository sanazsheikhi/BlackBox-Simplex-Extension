function [str] = result_message(result, dt)
    statements = {'AC command causes collision between agents %d and %d, d = %f',...
                  'BC command sequence causes collision between agents %d and %d at predicted step %d, d = %f',...
                  'Final velocities are not diverging between agents %d and %d'};

    % failure statement
    switch result.cause
        case 1
            failure_str = sprintf(statements{result.cause}, result.pair(1), result.pair(2), result.pair(3));            
        case 2
            failure_str = sprintf(statements{result.cause}, result.pair(1), result.pair(2), result.pair(4), result.pair(3));
        case 3
            failure_str = sprintf(statements{result.cause}, result.pair(1), result.pair(2));
    end
    % switch statement
    str = ['Switch at time: ' num2str(dt * result.switch_step) ', ' failure_str];
end


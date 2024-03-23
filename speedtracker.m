function [result, status] = speedtracker(varargin)
    % Entry point for speedtracker, which runs performance benchmarks against various previous states of the
    % project, called snapshots.

    %% init: set constants
    DEBUG = 0;

    [SRC_BASEDIR, ~, ~] = fileparts(mfilename('fullpath'));
    SRC_ST_DIR = fullfile(SRC_BASEDIR, 'speedtracker');

    OS_TEMP_DIR = tempdir();
    ST_DIR = 'speedtracker_temp';
    ST_TEMP_DIR = fullfile(OS_TEMP_DIR, ST_DIR);

    % Ensure we are in the project root directory
    oldPwd = pwd();
    cd(SRC_BASEDIR);

    %% setup: create temp dir and put all of Speedtracker's files there
    % Ensures that speedtracker does not get messed up when a different snapshot is loaded (because its own files could
    % change)
    if (exist(ST_TEMP_DIR, 'dir'))
        rmdir(ST_TEMP_DIR, 's');
    end
    copyfile(SRC_ST_DIR, ST_TEMP_DIR);
    addpath(genpath(ST_TEMP_DIR));

    %% to avoid clashes, ensure that the original speedtracker folder is not on the path
    if (contains(path, SRC_ST_DIR))
        rmpath(genpath(SRC_ST_DIR));
        rehash();
    end

    %% Global configuration required for the business code
    % The available subcommands (`speedtracker('list-snapshots')`, `speedtracker('run')`, etc.). They implement the
    % interface UserCommand, which makes adding new commands easy and clean.
    help = HelpCommand();
    commands = {help, CreateSnapshotCommand(), DeleteSnapshotCommand(), ...
        ListSnapshotsCommand(), ShowSnapshotCommand(), RunBenchmarksCommand(), RestoreStateCommand()};

    config = SpeedtrackerConfig();
    config.baseDir = SRC_BASEDIR;
    config.speedtrackerDir = SRC_ST_DIR;
    config.tempDir = ST_TEMP_DIR;
    config.userCommands = commands;
    ConfigProvider.setSpeedtrackerConfig(config);
    ConfigProvider.setUserConfig(UserConfig());

    % An extra logger to log system commands in debug mode
    systemLogger = makeSystemLogger();
    if (DEBUG)
        systemLogger.level = Logger.LEVEL_DEBUG;
    end
    SystemUtil.setGetLogger(systemLogger);

    try 
        % Handle args. If there are none, print the output of the HelpCommand
        if nargin == 0
            varargin = {help.getName()};
        end
        command = getCommand(commands, varargin);
        commandConfig = command.handleArgs(varargin);
    catch argError % can be either an unknown command or bad arguments to that command
        result = sprintf('%s\n\nERROR: %s', help.generalHelp(), argError.message);
        status = 1;
        teardown();
        return;
    end

    %% Business code: execute the selected command
    try
        commandLogger = makeCommandLogger(command.getName());
        if (DEBUG)
            commandLogger.level = Logger.LEVEL_DEBUG;
        end
        result = command.execute(commandLogger, commandConfig);
        status = 0;
    catch error
        if strcmp(error.identifier, UserCommand.ERROR_EXPECTED_EXCEPTION)
            result = sprintf('ERROR: %s: %s', command.getName(), error.message);
        else
            result = sprintf('unexpected error in %s\n\n%s', command.getName(), getReport(error));
        end
        status = 1;
    end

    teardown();

    %% teardown
    function teardown()
        rmpath(genpath(ST_TEMP_DIR));
        rmdir(ST_TEMP_DIR, 's');
        cd(oldPwd);
        rehash();
    end
end

function command = getCommand(commands, argCell)
    % Given a cell array of UserCommand objects and a cell array of program arguments,
    % select the correct UserCommand based on the first argument.
    % If the argument list is empty or the first argument does not match any command, throw an exception.
    if isempty(argCell)
        throw(MException('speedtracker:main', 'no inputs'));
    end
    arg1 = argCell{1};
    command = UserCommand.getCommand(commands, arg1);
    if isempty(command)
        throw(MException('speedtracker:main', ['unknown command: ' strjoin(string(arg1), ', ')]));
    end
end

function logger = makeCommandLogger(commandName)
    % Make a logger for a UserCommand.
    % Prepends the command as a prefix and logs everything except debug messages.
    logger = SimpleLogger(1);
    logger.debugPrefix = ['DEBUG(' commandName '): '];
    logger.infoPrefix = ['INFO (' commandName '): '];
    logger.warnPrefix = ['WARN (' commandName '): '];
    logger.errorPrefix = ['ERROR(' commandName '): '];
end

function logger = makeSystemLogger()
    % Make an extra logger for the SystemUtil, which handles calls to the host OS
    logger = SimpleLogger(1);
    logger.debugPrefix = 'DEBUG(SystemUtil): ';
    logger.infoPrefix = 'INFO (SystemUtil): ';
    logger.warnPrefix = 'WARN (SystemUtil): ';
    logger.errorPrefix = 'ERROR(SystemUtil): ';
end
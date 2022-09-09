classdef Logging % < FatherClass

    %read-only protected properties
    properties (Constant=true, Access=protected)
       all_levels = {"debug","info","warning","error"};
       info_levels = {"info","warning","error"};
       warning_levels = {"warning","error"};
       error_levels = {"error"};
    endproperties

    % protected properties
    properties (Access=protected)
       current_admit_levels = {"info","warning","error"};
       message = '';
       flg_out = false;
    endproperties

    % public properties
    properties(Access=public)
        level="info";
        output='';
        filename = '';
    endproperties

    %methods (Static = true)
    %  function lvs = levels()
    %    lvs = obj.all_levels
    %  endfunction
    %endmethods

    methods(Access=protected)
      function msg = message_template(obj,level, message)
        now = strftime ("%Y-%m-%e %H:%M:%S,000", localtime (time ()));
        msg = strcat(now,{" | "} , obj.filename, {" | "} , toupper(level), {" | "}, message){1};
      endfunction

      function to_file (obj,msg)
        disp(msg);
        fid = fopen (obj.output, "a");
        fdisp(obj.output,msg);
        fclose (fid);
      endfunction

      function to_output_only (obj,msg)
        disp(msg);
      endfunction
    endmethods

    methods(Access=public)
        function obj = Logging (level="info",outputfilepath='',filename='default')
          % Check if the logging level exist
          valid_choice = any(strcmp(obj.all_levels,level));
          if valid_choice
             obj.level = level;
          else
             error ("possible levels are: debug info warning error");
          endif

          switch (obj.level)
            case "debug"
              obj.current_admit_levels = obj.all_levels;
            case "info"
              obj.current_admit_levels = obj.info_levels;
            case "warning"
              obj.current_admit_levels = obj.warning_levels;
            case "error"
              obj.current_admit_levels = obj.error_levels;
            otherwise
              % this never happens, anyways...
              error ("possible levels are: debug info warning error");
          endswitch
          % Set ouput file name

          if  !strcmp(outputfilepath, '')
            obj.flg_out = true;
            obj.output = outputfilepath;
          else
            obj.flg_out = false;
          endif

          obj.filename = filename;


        endfunction

        function error (obj,message)
          msg = obj.message_template('error',message);

          flg_log = any(strcmp(obj.current_admit_levels,obj.level));

          if obj.flg_out && flg_log,
            obj.to_file(msg);
          elseif flg_log,
            obj.to_output_only(msg);
          else,
            obj.to_output_only(msg);
          endif

        endfunction

        function warning (obj,message)
          msg = obj.message_template('warning',message);

          flg_log = any(strcmp(obj.current_admit_levels,obj.level));

          if obj.flg_out && flg_log,
            obj.to_file(msg);
          elseif flg_log,
            obj.to_output_only(msg);
          else,
            obj.to_output_only(msg);
          endif

        endfunction

        function info(obj,message)
          msg = obj.message_template('info',message);

          flg_log = any(strcmp(obj.current_admit_levels,obj.level));

          if obj.flg_out && flg_log,
            obj.to_file(msg);
          elseif flg_log,
            obj.to_output_only(msg);
          else,
            obj.to_output_only(msg);
          endif
        endfunction

        function debug(obj,message)
          msg = obj.message_template('debug',message);

          flg_log = any(strcmp(obj.current_admit_levels,obj.level));

          if obj.flg_out && flg_log,
            obj.to_file(msg);
          elseif flg_log,
            obj.to_output_only(msg);
          else,
            obj.to_output_only(msg);
          endif
        endfunction

    endmethods
end

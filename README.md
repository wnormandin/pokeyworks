# pokeyworks
## Project framework, helper functions, and other core project tools

###### PokeyWorks is a framework containing several convenient utilities for general project development
###### (path resolver, word pluralization, project config files, terminal colors, and others).

### Attributes
###### Permissions Constants (used with Linux filesystem operations)
* PERM_0777=0o777
* PERM_0755=0o755
* PERM_0700=0o700
* PERM_0666=0o666
* PERM_0644=0o644
* PERM_0600=0o600
* PERM_0000=0o000

###### Encoding Libraries (True/False) Required for some PokeyConfig operations
* JSON_ENABLED
* YAML_ENABLED

### Methods
###### Logging
* __setup_logger(name, level, lpath='./tmp/last_run.log',fpath=\_\_name\_\_)__
  * name = an arbitrary name for this logger
  * level = logging.LEVEL, options are : logging.DEBUG, logging.INFO, logging.WARNING, logging.ERROR
    * if the level is logging.DEBUG, an additional logging handler is added for last_run, otherwise the output will default to console output only
  * lpath = output path for logging output, will attempt to create if it does not exist
  * fpath = intended execution base_path (either default, or the calling script's \_\_name\_\_ field contents)
  * returns a logging.Logger, read the [documentation](https://docs.python.org/2/library/logging.html) for usage

###### Word Pluralization
* __plurals(word,qty)__
  * word = the word to be pluralized in American English
  * qty = the quantity of the item
  * returns a string containing the pluralized version of word, ~90% accurate

###### Terminal Colors
* __color_wrap(val,color)__
  * val = a string to be wrapped
  * color = the ASCII color code to use
  * returns val with the color code prepended, and an ASCII code to return to normal formatting following the string

###### File Paths
* __resource_path(fpath,rel_path)__
  * where fpath is the base_dir and rel_path is the relative path to the resource
  * returns the absolute path to the resource in rel_path

###### Misc.
* __chk_deps(mods)__
  * mods is in ['gtk','sys','multiprocessing','os','logging','csv','socket','random','time','subprocess']
  * returns True if the passed module list is successfully loaded
* __read_csv(fpath, delim=',',qchar="'")__
  * fpath = inputh file path
  * delim = field delimiter
  * qchar = quote character to wrap strings containing delim
  * returns a list = [row for row in csvobj] where csvobj is the successfully read file
  * Exceptions raised by default
* __valid_date(s)__
  * where s is a datetime string of any format
  * returns the standardized date datetime.strptime(s, "%Y-%m-%d")
  * returns False if conversion fails
* __shell_command(cmd_str, sh=False)__
  * cmd_str is a linux shell command string
  * sh indicates whether to execute in a subshell, default to False for security
  * uses subprocess.Popen to execute the command
  * returns the resulting output from subprocess.Popen...communicate()[0]
* __install_module(path, mod)__
  * installs the specified module at the specified path using easy_install
  * use when you absolutely must install a dependency locally
* __mkdir(dpath, perms=PERM_0644)__
  * creates the directory specified in dpath with the permissions set by perms, if it does not exist
  * returns a 2-tuple - ( False, Exception ) in the case of an Exception
  * returns dpath,perms if successful

### Classes
###### Application Configuration
* __PokeyConfig.\_\_init\_\_(self, fpath, conf_type=1, auto_apply=False)__
  * self = self instance of class PokeyConfig
  * fpath = path to a JSON, YAML, delimited, or Base64-encoded JSON file (prefer basic elements!)
  * conf_type=1 : configuration type designator, utility will make a guess but currently buggy, required
    * Values : PokeyConfig.json=1, PokeyConfig.yaml=2, PokeyConfig.encoded=3, PokeyConfig.[DELIMITER]
      * [DELIMITER] pipe = '|', tab = '\t', semicolon = ';', comma = ',', percent = '%'
      * If a DELIMITER is passed, the file will be converted, either to JSON, YAML, or Base64-encoded JSON after reading
  * auto_apply=False : if True, each item is applied as a dot-referencable attribute of the class in addition to default behavior
  * PokeyConfig.conf_dict contains the loaded config, where each key corresponds to a dictionary key from the configuration file
  * If auto_apply==True, each key in the PokeyConfig.conf_dict is applied as an attribute of the class, i.e. PokeyConfig.key=val
  * Requirements : json (in standard lib), yaml (for yaml operations only), base64, cStringIO
* __PokeyConfig.load_config(self, conf_type, inpath=None)__
  * Invoked by \_\_init\_\_ to load the file path
  * Can be invoked separately to open additional files to replace the exiting conf_dict
  * Automatically converts delimited files
  * Will NOT remove applied attributes, this is intended to allow multiple configuration settings to be read from multiple files and consolidated in a single configuration class instance
  * Uses :
    * PokeyConfig.load_delimited - used in the delimited conversion routine
    * PokeyConfig.load_json
    * PokeyConfig.load_yaml
    * PokeyConfig.do_decode - used to decode base64-encoded JSON files (default extension .cfg)
* __PokeyConfig.write_config(self,**kw)__
  * currently expects no kwargs
  * used to save the loaded configuration, based on the loaded_type class attribute
  * PokeyConfig.loaded_type is set during the load_config routine, if you are manually changing the loaded configurations, be sure to set the loaded_type to your desired output before calling write_config
  * Uses :
    * PokeyConfig.save_json
    * PokeyConfig.save_yaml
    * PokeyConfig.do_encode
* __PokeyConfig.convert_config(self, out_type)__
  * out_type is in [PokeyConfig.json, PokeyConfig.yaml, PokeyConfig.encoded]
  * converts the configuration, saving the config as a new file with an appropriate extension
  * removes the existing configuration file
  * Uses :
    * PokeyConfig.rm_config
    * PokeyConfig.convert_file_path

###### Daemon class
* __Daemon.\_\_init\_\_(self, pidfile, stdin='/dev/null', stdout='/dev/null', stderr='/dev/null')__
  * Daemon superclass, the Daemon.run method __must__ be overruled by the child class
  * Usage:
    * inst = DaemonChild(pidfile_path)  \# Initialize the child class instance
    * inst.start()  \# Performs basic integrity checks, then double-forks to orphaned process, executing inst.run()
    * inst.restart()  \# Restarts the daemon, running inst.stop(); inst.start()
    * inst.stop()  \# Closes the daemon pidfile
  * The magical double-fork happens in the DaemonChild.daemonize() method invoked in DaemonChild.start()

###### Terminal Colors (basic ASCII list)
* __Color__
  * Color.BLACK_ON_GREEN = '\x1b[1;30;42m'
  * Color.PURPLE = '\033[95m'
  * Color.CYAN = '\033[96m'
  * Color.DARKCYAN = '\033[36m'
  * Color.BLUE = '\033[94m'
  * Color.GREEN = '\033[92m'
  * Color.YELLOW = '\033[93m'
  * Color.RED = '\033[91m'
  * Color.BOLD = '\033[1m'
  * Color.UNDERLINE = '\033[4m'
  * Color.END = '\033[0m'
* __ColorIze.\_\_init\_\_(self, val, opts)__
  * wraps the passed_val with the list in opts
  * no return, access the colorized attribute ColorIze.colorized

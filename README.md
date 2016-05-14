# pokeyworks
## Project framework, helper functions, and other core project tools

PokeyWorks is a framework containing several convenient utilities for
general project development (path resolver, word pluralization, 
project config files, terminal colors, and others).

### Attributes
Permissions Constants (used with Linux filesystem operations)
* PERM_0777=[0o777,'fd'] # File/Dir
* PERM_0755=[0o755,'fd'] # File/Dir
* PERM_0700=[0o700,'fd'] # File/Dir
* PERM_0666=[0o666,'f']
* PERM_0644=[0o644,'f']
* PERM_0600=[0o600,'f']
* PERM_0000=[0o000,'fd'] # File/Dir

Encoding Libraries (True/False) Required for some PokeyConfig operations
* JSON_ENABLED
* YAML_ENABLED

Terminal Colors (basic ASCII list)
* class Color
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

### Methods
Logging
* setup_logger(name, level, lpath='./tmp/last_run.log',fpath=\_\_name\_\_)
  * name = an arbitrary name for this logger
  * level = logging.LEVEL, options are : logging.DEBUG, logging.INFO, logging.WARNING, logging.ERROR
    * if the level is logging.DEBUG, an additional logging handler is added for last_run, otherwise the output will default to console output only
  * lpath = output path for logging output, will attempt to create if it does not exist
  * fpath = intended execution base_path (either default, or the calling script's \_\_name\_\_ field contents)
  * returns a logging.Logger, read the [documentation](https://docs.python.org/2/library/logging.html) for usage

Word Pluralization
* plurals(word,qty)
  * word = the word to be pluralized in American English
  * qty = the quantity of the item
  * returns a string containing the pluralized version of word, ~90% accurate

Terminal Colors
* color_wrap(val,color)
  * val = a string to be wrapped
  * color = the ASCII color code to use
  * returns val with the color code prepended, and an ASCII code to return to normal formatting following the string

File Paths
* resource_path(fpath,rel_path)
  * where fpath is the base_dir and rel_path is the relative path to the resource
  * returns the absolute path to the resource in rel_path

Misc.
* chk_deps(mods)
  * mods is in ['gtk','sys','multiprocessing','os','logging','csv','socket','random','time','subprocess']
  * returns True if the passed module list is successfully loaded
* read_csv(fpath, delim=',',qchar="'")
  * fpath = inputh file path
  * delim = field delimiter
  * qchar = quote character to wrap strings containing delim
  * returns a list = [row for row in csvobj] where csvobj is the successfully read file
  * Exceptions raised by default
* valid_date(s)
  * where s is a datetime string of any format
  * returns the standardized date datetime.strptime(s, "%Y-%m-%d")
  * returns False if conversion fails

### Classes
Application Configuration
* PokeyConfig.\_\_init\_\_(self, fpath, conf_type=1, auto_apply=False)
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
* PokeyConfig.load_config(self, conf_type, inpath=None)
  * Invoked by \_\_init\_\_ to load the file path
  * Can be invoked separately to open additional files to replace the exiting conf_dict
  * Automatically converts delimited files
  * Will NOT remove applied attributes, this is intended to allow multiple configuration settings to be read from multiple files and consolidated in a single configuration class instance
  * Uses :
    * PokeyConfig.load_delimited - used in the delimited conversion routine
    * PokeyConfig.load_json
    * PokeyConfig.load_yaml
    * PokeyConfig.do_decode - used to decode base64-encoded JSON files (default extension .cfg)
* PokeyConfig.write_config(self,**kw)
  * currently expects no kwargs
  * used to save the loaded configuration, based on the loaded_type class attribute
  * PokeyConfig.loaded_type is set during the load_config routine, if you are manually changing the loaded configurations, be sure to set the loaded_type to your desired output before calling write_config
  * Uses :
    * PokeyConfig.save_json
    * PokeyConfig.save_yaml
    * PokeyConfig.do_encode
* PokeyConfig.convert_config(self, out_type)
  * out_type is in [PokeyConfig.json, PokeyConfig.yaml, PokeyConfig.encoded]
  * converts the configuration, saving the config as a new file with an appropriate extension
  * removes the existing configuration file
  * Uses :
    * PokeyConfig.rm_config
    * PokeyConfig.convert_file_path

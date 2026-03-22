{lib}: let
  inherit (lib) concatStringsSep mapAttrsToList optionalString filterAttrs;
  inherit (builtins) typeOf elem replaceStrings;

  sanitize = s:
    replaceStrings
    ["\n" ''"'' "\\" "\r" "\t"]
    ["\\n" ''\"'' "\\\\" "\\r" "\\t"]
    s;

  toLiteral = v:
    if v == null
    then "null"
    else if v == true
    then "true"
    else if v == false
    then "false"
    else if typeOf v == "string"
    then ''"${sanitize v}"''
    else toString v;

  indent = s:
    concatStringsSep "\n"
    (map (line: "    ${line}") (lib.splitString "\n" s));

  # Convierte una lista de attrsets en nodos KDL consecutivos (para _children)
  convertChildren = list:
    concatStringsSep "\n"
    (map (
        child:
          concatStringsSep "\n" (mapAttrsToList convertAttr child)
      )
      list);

  convertAttr = name: value: let
    t = typeOf value;
  in
    if elem t ["int" "float" "bool" "string" "null"]
    then "${name} ${toLiteral value}"
    else if t == "set"
    then convertSet name value
    else if t == "list"
    then convertList name value
    else throw "toKDL: unsupported type `${t}` for attribute `${name}`";

  convertSet = name: attrs:
    if attrs == {}
    then name
    else let
      argsStr =
        optionalString (attrs ? _args)
        (concatStringsSep " " (map toLiteral attrs._args) + " ");

      propsStr =
        optionalString (attrs ? _props)
        (concatStringsSep " "
          (mapAttrsToList (k: v: "${k}=${toLiteral v}") attrs._props)
          + " ");

      # _children se aplana como nodos consecutivos dentro del bloque
      childrenStr =
        optionalString (attrs ? _children)
        (convertChildren attrs._children);

      rest = filterAttrs (k: _: !elem k ["_args" "_props" "_children"]) attrs;
      restStr = concatStringsSep "\n" (mapAttrsToList convertAttr rest);

      allChildren =
        concatStringsSep "\n"
        (lib.filter (s: s != "") [childrenStr restStr]);
    in
      "${name} ${argsStr}${propsStr}"
      + (
        if allChildren != ""
        then " {\n${indent allChildren}\n}"
        else ""
      );

  convertList = name: list:
    if list == []
    then name
    else let
      isListOfLists = builtins.all (el: typeOf el == "list") list;
      isFlat = builtins.all (el: elem (typeOf el) ["int" "float" "string" "bool" "null"]) list;
    in
      if isListOfLists
      then
        concatStringsSep "\n"
        (map (sub: "${name} ${concatStringsSep " " (map toLiteral sub)}") list)
      else if isFlat
      # <- una sola línea con todos los args, no un nodo por elemento
      then "${name} ${concatStringsSep " " (map toLiteral list)}"
      else concatStringsSep "\n" (map (el: convertAttr name el) list);
in
  # _children al nivel raíz también se aplana
  attrs: let
    topChildren =
      optionalString (attrs ? _children)
      (convertChildren attrs._children);
    rest = filterAttrs (k: _: k != "_children") attrs;
    restStr = concatStringsSep "\n" (mapAttrsToList convertAttr rest);
  in
    concatStringsSep "\n" (lib.filter (s: s != "") [restStr topChildren]) + "\n"

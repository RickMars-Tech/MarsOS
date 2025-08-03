{
  # don't need these default ones
  "amazondotcom-us".metaData.hidden = true;
  "bing".metaData.hidden = true;
  "ebay".metaData.hidden = true;
  "Startpage" = {
    urls = [
      {
        template = "https://www.startpage.com/sp/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [",d"];
  };
  "Home Manager Options" = {
    urls = [
      {
        template = "https://mipmip.github.io/home-manager-option-search/";
        params = [
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = ["ho"];
  };
  "Nix Packages" = {
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = ["np"];
  };
  "youtube" = {
    urls = [
      {
        template = "https://www.youtube.com/results";
        params = [
          {
            name = "search_query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = ["y"];
  };
  "Wikipedia" = {
    urls = [
      {
        template = "https://en.wikipedia.org/wiki/Special:Search";
        params = [
          {
            name = "search";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = ["wik"];
  };
  "GitHub" = {
    urls = [
      {
        template = "https://github.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = ["gh"];
  };
}

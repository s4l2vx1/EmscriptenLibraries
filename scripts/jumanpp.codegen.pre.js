Module.preRun = [
    function () 
    {
      const repositoryDir = `${process.env["RepositoryDir"]}/${process.env["RepositoryName"]}`; 

      const dirNames = repositoryDir.split("/").filter(i => !!i);
      let currentDir = "";

      for (const name of dirNames)
      {
        currentDir += "/" + name;

        try {
          FS.stat(currentDir)
        } catch(_) {
          FS.mkdir(currentDir)
        }
      }
     
      FS.mount(NODEFS, { root: repositoryDir }, repositoryDir);
      
      /** @type { string } */
      const executableName = process.argv[1];

      FS.symlink(executableName, '/proc/self/exe');

      FS.chdir(`${repositoryDir}/${process.env["BuildDirName"]}`);
    }
]
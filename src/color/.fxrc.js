const _ = require("lodash")

function flattenBookmarksAsProjects(bookmarks) {
    let allProjects = [];
  
    function createProject(bookmark) {
      const project = {
        name: bookmark.title,
        dependencies: [],
        testMatch: [],
        use: { mounts: [] }
      };
  
      // Collect GUIDs for type 1 bookmarks (individual URLs)
      if (bookmark.uri && bookmark.typeCode === 1) {
        project.testMatch.push(`*.${child.guid}.spec.ts`);
      }
  
      // If it has children, process them and categorize as dependencies or test matches
      if (bookmark.children && bookmark.children.length > 0) {
        bookmark.children.forEach((child) => {
          if (child.typeCode === 2) {
            project.dependencies.push(child.title);
            createProject(child); // Recursively process child folders
          } else if (child.typeCode === 1 && child.uri) {
            project.testMatch.push(`*.${child.guid}.spec.ts`);
            project.use.mounts.push(child)
          }
        });
      }
  
      allProjects.push(project);
    }
  
    bookmarks.forEach(bookmark => createProject(bookmark));
  
    return _.filter(allProjects, x => x.testMatch.length > 1);
  }

  function getDevContainerLabels(bookmarks) {
    let flatList = [];
  
    function collectType1Bookmarks(bookmark) {
      if (bookmark.typeCode === 1) {
        // Map each typeCode 1 bookmark to the specified format
        const label = `tests/${bookmark.title}.${bookmark.guid}.spec.ts:Actor.spec.ts`;
        flatList.push(label);
      }
  
      // Recursively process children if they exist
      if (bookmark.children && bookmark.children.length > 0) {
        bookmark.children.forEach(child => collectType1Bookmarks(child));
      }
    }
  
    // Start the recursive collection
    bookmarks.forEach(bookmark => collectType1Bookmarks(bookmark));
  
    return flatList;
  }

  global.getDevContainerLabels = getDevContainerLabels
  
  global.flattenBookmarksAsProjects = flattenBookmarksAsProjects
  global.HERE = () => console.log('HERE')
// Remove /tmp/color directory before executing any stage
async function run(stage, template, mounts) {
  try {
    // Run the shell script and wait for the response
    const result = await $`./.github/actions/smoke-test/${stage}.sh ${template} `;
    console.log('Shell script output:', result.stdout);
  } catch (error) {
    console.error('Error running shell script:', error);
  }
}
// Execute the function
// TODO ARGV[0]=template, ...stages
// zx README.md color build test
// echo "Building Dev Container"
// ID_LABEL="test-container=${TEMPLATE_ID}"
const template = 'color'

// await $`docker stop $(docker ps -q)`
// await $`docker rm $(docker ps -aq)`
await $`rm -rf /tmp/${template}`;
await run('build', `${template}`);

// await $`"`
await run('test', `${template}`);
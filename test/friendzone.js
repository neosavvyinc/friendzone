const Friendzone = artifacts.require("Friendzone");

/*
 *
instance.allEvents().watch(function(error, event){
   if (error) {
       console.log("Error: " + error);
   } else {
       console.log(event.event + ": " + JSON.stringify(event.args));
   }
});
*/

contract('Friendzone', function(accounts) {
  it('should create a new plan', function() {
    return Friendzone.deployed()
      .then((instance) => {
        // Use .call() if you want to return the actual return value and not the TX object.
        return instance.createNewPlan.call('My new plan', [accounts[0], accounts[1], accounts[2]]);
      })
      .then(planAddress => {
        assert.isAddress(planAddress);
      });
  });

  it('should emit that a new plan has been created', function() {
    return Friendzone.deployed()
      .then((instance) => {
        const events = instance.allEvents();
        events.watch(function(error, event) {
          assert.equal(event.event, 'NewPlanCreated');
          assert.isAddress(event.args.planAddress);
          // .stopWatching() is needed to stop testprc from hanging at eth_getFiltersChanges
          events.stopWatching();
        });

        return instance.createNewPlan('My new plan', [accounts[0], accounts[1], accounts[2]]);
      });
  });
})


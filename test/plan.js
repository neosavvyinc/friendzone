const Plan = artifacts.require("Plan");

contract('Plan', function(accounts) {

  it('should set the owner as the sender when constructed', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        return instance.owner();
      })
      .then(owner => {
        assert.equal(owner, accounts[0]);
      });
  });

  it('should set the name when constructed', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        return instance.name();
      })
      .then(name => {
        // Convert from bytes32 to utf8 without trailing zeroes
        assert.equal(web3.toUtf8(name), 'My Plan');
      });
  });

  it('should set the members when constructed', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        // From the Solidity FAQ:
        // The automatic getter function for a public state variable of array type only returns individual elements. If you want to return the complete array, you have to manually write a function to do that.
        return instance.getMemberAtIndex.call(0);
      })
      .then(firstMember => {
        assert.equal(firstMember, accounts[0]);
      });
  });

  it('should set the members map when constructed', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        // From the Solidity FAQ:
        // The automatic getter function for a public state variable of array type only returns individual elements. If you want to return the complete array, you have to manually write a function to do that.
        return instance.checkIfMember.call(accounts[1]);
      })
      .then(isMember => {
        assert.isTrue(isMember);
      });
  });

  it('should transfer the ownership to another address', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        instance.allEvents().watch(function(error, event) {
          assert.equal(event.event, 'OwnershipTransferred');
          assert.equal(event.args.newOwner, accounts[1]);
        })
        return instance.transfer(accounts[1]);
      });
  });

  it('should add a member', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        return instance.addMember(accounts[3])
          .then(() => {
            return instance.getMemberAtIndex.call(2);
          })
          .then(newMember => {
            assert.equal(newMember, accounts[3]);
          });
      });
  })

  // TODO: FIX THIS TEST
  // it('should throw if you are not the owner', function() {
  //   Plan.new('My Plan', [accounts[0], accounts[1]])
  //     .then(instance => {
  //       instance.transfer(accounts[1])
  //         .then(() => {
  //           return instance.addMember(accounts[3]);
  //         })
  //       .then(assert.fail)
  //        .catch(function(error) {
  //          console.log(error.message)
  //               assert(
  //                   error.message.indexOf('out of gas') >= 0,
  //                   'red cars should throw an out of gas exception.'
  //               )
  //        });
  //     })
  // });


  it('should add a new initiative to the initiatives array', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        instance.addInitiative(
          3,
          'name of the initiative',
          'description of the initiative'
        )
          .then(() => {
            return instance.getInitiativesLength.call();
          })
          .then(length => {
            assert.equal(length, 1);
          });
      });
  });

  it('should emit a new initiative added event with the address of the new initiative', function() {
    Plan.new('My Plan', [accounts[0], accounts[1]])
      .then(instance => {
        instance.allEvents().watch(function(error, event) {
          assert.equal(event.event, 'NewInitiativeAdded');
          assert.isAddress(event.args.initiative);
        })
        return instance.addInitiative(
          3,
          'name of the initiative',
          'description of the initiative'
        )
      });
  });
})


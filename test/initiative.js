const Initiative = artifacts.require("Initiative");

contract('Initiative', function(accounts) {
  // TODO: Figure out how to test `require`s
  // it('should require an amount of votes needed higher than 0', function() {
  //   Initiative.new([accounts[0], accounts[1]], 0, 'My Initiative', 'Cool plan description')
  //     .then(assert.fail)
  //     .catch(error => {
  //       assert(true);
  //     })
  // });
  it('should create a mapping with the members set to true', function() {
    Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
      .then(instance => {
        return instance.isMember.call(accounts[1]);
      })
      .then(isMember => {
        assert(isMember);
      })
  });
  it('should initialize the initiative as closed', function() {
    Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
      .then(instance => {
        return instance.isOpen()
      })
      .then(isOpen => {
        assert(!isOpen);
      })
  });
  it('should let a member vote', function() {
    Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
      .then(instance => {
        return instance.openVoting()
          .then(() => {
            return instance.vote(true)
              .then(() => {
                return instance.voterValue.call(accounts[0]);
              })
              .then(vote => {
                assert(vote, true);
              });
          });
      });
  });
  it('should not let a member vote', function() {
    // TODO: TBD
  });
  it('should not let the member vote if the voting is closed', function() {
    // TODO: TBD
  });
  it('should increase the positive votes if the member votes yes', function() {
    Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
      .then(instance => {
        return instance.openVoting()
          .then(() => {
            return instance.vote(true);
          })
          .then(() => {
            return instance.getPositiveVotes();
          })
          .then(positiveVotes => {
            assert(positiveVotes, 1);
          });
      });
  });

  // TODO: BEWARE
  //it('should pass the initiative if there are more votes than the ones needed', function() {
  //  Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
  //    .then(instance => {
  //      return instance.openVoting()
  //        .then(() => {
  //          return instance.vote(true);
  //        })
  //        .then(() => {
  //          return instance.result();
  //        })
  //        .then(result => {
  //          assert(result);
  //        });
  //    });
  //});
  //it('should emit the voters address and their choice when they vote', function() {
  //  Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
  //    .then(instance => {
  //      return instance.openVoting()
  //        .then(() => {
  //          instance.allEvents().watch(function(error, event) {
  //            assert.equal(event.event, 'NewVoteCasted');
  //            assert.equal(event.args.voter, accounts[0]);
  //            assert.equal(event.args.value, true);
  //          })
  //          return instance.vote(true);
  //        });
  //    });
  //});
  //it('should let the admin open the initiative for voting', function() {
  //  Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
  //    .then(instance => {
  //      return instance.openVoting()
  //        .then(() => {
  //          return instance.isOpen();
  //        })
  //        .then(isOpen => {
  //          assert(isOpen);
  //        });
  //    });
  //});
  //it('should not let anyone but the admin open the initiative for voting', function() {
  //  //TODO: TBD
  //});
  //it('should let the admin close the initiative', function() {
  //  Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
  //    .then(instance => {
  //      return instance.openVoting()
  //        .then(() => {
  //          return instance.closeVoting();
  //        })
  //        .then(() => {
  //          return instance.isOpen();
  //        })
  //        .then(isOpen => {
  //          assert(!isOpen);
  //        });
  //    });
  //});
  //it('should not let anyone but the admin close the initiative', function() {
  //  // TODO: TBD
  //});
  //it('should let the admin change the name of the initiative', function() {
  //  Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
  //    .then(instance => {
  //      return instance.changeName('Other name')
  //        .then(() => {
  //          return instance.name();
  //        })
  //        .then(name => {
  //          assert.equal(web3.toUtf8(name), 'Other name');
  //        });
  //    });
  //});
  //it('should let the admin change the description of the initiative', function() {
  //  Initiative.new([accounts[0], accounts[1]], 1, 'My Initiative', 'Cool plan description')
  //    .then(instance => {
  //      return instance.changeDescription('Other description')
  //        .then(() => {
  //          return instance.description();
  //        })
  //        .then(description => {
  //          assert.equal(web3.toUtf8(description), 'Other description');
  //        });
  //    });
  //});
  // it('should let the admin add a new member to the initiative', function() {
  //   Initiative.new([accounts[0]], 1, 'My Initiative', 'Cool plan description')
  //     .then(instance => {
  //       return instance.addMember(accounts[1])
  //         .then(() => {
  //           return instance.isMember.call(accounts[1]);
  //         })
  //         .then(isNewMember => {
  //           assert(isNewMember);
  //         });
  //     });
  // });
  it('should not let the admin add a new member to the initiative if the member is already part of it', function() {
    // TODO: TBD
  });
});


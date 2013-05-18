#Playhouse

A framework for structing a ruby application using the DCI (Data, Context and Interaction)
pattern. Playhouse makes no assumptions about whether it's a web app (or any other sort),
it just helps you to structure your application logic. Playhouse is not used to structure
presentation logic, it is typically connected to some sort of delivery layer.

[![Code Climate](https://codeclimate.com/github/enspiral/playhouse.png)](https://codeclimate.com/github/enspiral/playhouse)
[![Build Status](https://travis-ci.org/enspiral/playhouse.png)](https://travis-ci.org/enspiral/playhouse)
[![Coverage Status](https://coveralls.io/repos/enspiral/playhouse/badge.png?branch=master)](https://coveralls.io/r/enspiral/playhouse)

##Status

Playhouse is not yet at version 1.0.

It is being used for it's first production apps now, but it's interface may change rapidly and
at any point, so doing so it not advised unless you are actively involved in Playhouse
development.

##Installation

```ruby
  gem 'playhouse', git: 'git://github.com/enspiral/playhouse.git'
```

You may wish to organise your app such that the three main parts of the DCI pattern have their
own folders. We are currently using:

```
  lib/entities
  lib/roles
  lib/context
```

##Getting Started

There are three main parts of a Playhouse app, Entities, Roles and Contexts. Additionally,
there is some overall structure that makes it easy to create an entry point to the
application logic.

###Entities

Entities are the "Data" part of DCI. They represent you Domain models that you probably
want to persist to a data store of some sort. To avoid the sort of complexity that often
occurs in models in Rails apps, Playhouse entities should have no functionality other than
defining their data structure and connecting to the persistance layer.

Playhouse does not care what persistance library you use. ActiveRecord works fine, just add
the gem to your app and start using it. We recommend you don't use validations (Contexts do
validations in Playhouse), keep relationships to necessary ones only, and don't use scopes
(queries go in Roles).

Playhouse actually has no Entity class. This is just a concept that you need to create yourself.

Entities are often used as Actors by Contexts. Actors can also be other basic types (or indeed
any object).

### Roles

Roles are modules that are mixed into to Actors at runtime. Specifically note that they are
used to extend objects, no classes. If you're not familiar with this, go read up on DCI.

Playhouse defines a Role module to provide this behaviour, although it is implemented just
using Ruby's `extend` method. A role in your Playhouse app looks as follows:

```ruby
require 'playhouse/role'

module YourApp
  module TransferSource
    include Playhouse::Role

    actor_dependency :minimum_balance
    actor_dependency :bank

    def some_method
      # do something
    end
  end
end
```

Using a role is as simple as:

```ruby
TransferSource.cast_actor(my_account)
```

Although Contexts will do this for you automatically. Specifying actor dependencies on your
role is a good way of documenting the duck type that the role expects to extend. When you
call cast_actor, then it will raise an exception if the actor you supply does not support
the methods specified (minimum_balance and bank in the above example).

###Contexts

Each of your contexts is a command that your app performs, which you could also think of as
a use case. In essence, a context is supplied with Actors, "casts" them in various Roles and
then executes some behaviour. In keeping with conventions of most people using DCI in ruby,
executing a context is done by calling it's `call` method.

Playhouse provides a base Context class for you to derive from. Rather than implementing
`call` directly though, please override our `perform` method so that we can perform some
checks before your code executes. Here's an example.

```ruby
require 'playhouse/context'
require 'economatic/roles/account_transaction_collection'
require 'economatic/entities/account'

module Economatic
  class AccountBalanceEnquiry < Playhouse::Context
    actor :account, role: AccountTransactionCollection, repository: Account

    def perform
      account.balance
    end
  end
end
```
This Balance enquiry context is fairly simple. Your context perform method might have more
lines than this, and it might be good if it is lists the main high level steps for
performing this feature. However, the serious application logic goes into your roles.

To calculate a balance, this context just needs one actor, an account, and it casts it
as a role (AccountTransactionCollection) which actually knows how to calculate a balance
by summing transactions. Actors are all required be default (unless you specify the
`optional: true` option), and so building this context without an account will raise an
exception. Specifying the Account repository can be used to find accounts, allows other
parts of Playhouse to build this Context by asking Account to fetch an account given an
id. Remember as well tha the AccountTransactionCollection role will check that the account
has the methods it is dependent on.

The return value from your context is returned to the code calling your application
(which is often your delivery layer or another application), and we suggest that this
should be fairly dumb object. Context should return data, you shouldn't use their return value
in ways that transform it, save data, etc.

##An Interface to Your Application

The external interface of your application is essentially the Contexts that are available
to be called, although some Contexts might be just for calling from other Contexts. To
organise these a bit to present to the outside world, you can group these into an API
object which Playhouse calls a Play.

```ruby
require 'playhouse/play'

module Economatic
  class Play < Playhouse::Play
    context AccountBalanceEnquiry
    context ApproveTransfer
    context BankBalanceEnquiry
    context TransferMoney
  end
end
```

Contexts can be called via the play just as methods:

```ruby
play = Economatic::Play.new
play.account_balance_enquiry(account: some_account_object)
```

If you call a context this way, we also use our TalentScout to process the parameters you
supply and find actors if given ids, or build actors that are composed of several parts,
for example, this will work if calling via the play (but wouldn't work if you construct
the Context manually):

```ruby
play.account_balance_enquiry(account_id: 1)
```

The other advantage of a Play is that you can ask it about the context that it supports,
and the parts available for Actors in that context. This allows you to present structured
information about your API, such as auto-generating documentation.

###A Delivery Layer

While you can call methods on a Play directly, often this will be done from some user input
of some sort. This layer knows about how you are delivering your app (as a JSON web service,
a console app, a GUI app, etc), and it knows about your application somewhat (often by
interrogating your Plays). However, your core application should never know about your
delivery layer(s). Even if you're expecting to build a web app, don't put web concepts
into your app, make it generic.

Playhouse doesn't do delivery layers for you, but it provides a known structure to allow
other gems to help you out with this. We suggest you first try out our playhouse-console
gem which provides you with a simple console app with one command for each Context.

For a web app, it's quite possible to use Sinatra or Rails as your delivery layer.

##Licence

Playhouse is licenced under the MIT licence. Copyright 2013 Enspiral Services Ltd.

##Contributing

Your contributions are welcome. Send us a pull request, or start a discussion in the github
issues first.

##Credits

From Enspiral Craftworks:

* Craig Ambrose (@craigambrose)
* Joshua Vial (@joshuavial)

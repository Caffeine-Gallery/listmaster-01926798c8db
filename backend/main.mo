import Bool "mo:base/Bool";
import Func "mo:base/Func";
import Hash "mo:base/Hash";
import List "mo:base/List";

import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor {
  // Define the ShoppingItem type
  type ShoppingItem = {
    id: Nat;
    name: Text;
    completed: Bool;
  };

  // Initialize a stable variable to store the next item ID
  stable var nextId: Nat = 0;

  // Initialize a stable variable to store the shopping list items
  stable var stableItems: [(Nat, ShoppingItem)] = [];

  // Create a HashMap to store the shopping list items
  var shoppingList = HashMap.HashMap<Nat, ShoppingItem>(0, Nat.equal, Nat.hash);

  // Function to add a new item to the shopping list
  public func addItem(name: Text) : async Nat {
    let id = nextId;
    let newItem: ShoppingItem = {
      id = id;
      name = name;
      completed = false;
    };
    shoppingList.put(id, newItem);
    nextId += 1;
    id
  };

  // Function to update an item's completion status
  public func updateItem(id: Nat, completed: Bool) : async Bool {
    switch (shoppingList.get(id)) {
      case (null) { false };
      case (?item) {
        let updatedItem: ShoppingItem = {
          id = item.id;
          name = item.name;
          completed = completed;
        };
        shoppingList.put(id, updatedItem);
        true
      };
    };
  };

  // Function to delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    switch (shoppingList.remove(id)) {
      case (null) { false };
      case (?_) { true };
    };
  };

  // Query function to get all items in the shopping list
  public query func getAllItems() : async [ShoppingItem] {
    Iter.toArray(shoppingList.vals())
  };

  // System functions for upgrades
  system func preupgrade() {
    stableItems := Iter.toArray(shoppingList.entries());
  };

  system func postupgrade() {
    shoppingList := HashMap.fromIter<Nat, ShoppingItem>(stableItems.vals(), 0, Nat.equal, Nat.hash);
  };
}

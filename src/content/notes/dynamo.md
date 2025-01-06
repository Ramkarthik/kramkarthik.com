---
title: "Amazon DynamoDB"
createdDate: "2025-01-06"
modifiedDate: "2025-01-06"
tags: ["distributed-systems"]
garden: "seedling"
summary: "Notes from the Amazon's Dynamo DB paper"
---

Dynamo is Amazon's highly available key-value store.

Source: [Dynamo: Amazon’s Highly Available Key-value Store](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)

Context: Amazon uses a service oriented architecture consisting of a huge number of services. Handling failures is the default mode of operation for Amazon handling these many services. At any given time, there are many failing services. Dynamo is designed by keeping this in mind. It has to have high availability inspite of the many failing services. Dynamo sacrifices consistency under certain failure scenarios to achieve this level of high availability.

## Design

- *Eventually consistent* - updates reach all replicas eventually.
- *Always writeable* - Conflict resolution is handled during reads instead of writes so that writes are never rejected.
- *Conflict resolution* - The application has the option to be the conflict resolution owner but, in case it doesn't want to handle it, the store uses the "last write wins" approach for conflict resolution.
- *Incremental stability* - Can scale one node at a time with minimal impact to both the operators of the system and the system itself.
- *Symmetry* - Every node has the same responsibility (no ownership model).
- *Decentralized* - Centralized control can result in outages. Dynamo's design favors decentralization.
- *Heterogeneity* - Work can be distributed to nodes based on it's capacity.

## Core techniques (Challenge - Technique - Advantage)

- *Partitioning* - Consistency hashing - Incremental stability
- *High availability for writes* - Vector clocks with read reconciliation - Vector size is decoupled from update rates
- *Temporary failures* - Sloppy quorum and hinted handoff - High availability and durability even when some replicas are not available
- *Recovery from permanent failures* - Anti-entropy using Merkle trees - Synchronizes divergent replicas in the background
- *Membership and failure detection* - Gossip-based membership protocol - Preserves symmetry and avoids central ownership

## System interface

- `get(key)`- Returns a single object or a list of objects with conflicting versions along with a context.
- `put(key, context, object)` - Uses the key to identify where the replicas should be placed and writes the replicas to the disk.

Dynamo uses MD5 hash on the key, which is used to determine the storage nodes responsible for serving the key.

## Partitioning algorithm

Dynamo uses a variant of consistent hashing. The basic consistent hasing has two main problems: 1. Non uniform distribution, and 2. Non heterogeneity (doesn't consider the capacity of individual nodes).

In this variant, instead of mapping a node to a single point in the circle, each node is mapped to multiple points.

Each node now manages multiple virtual nodes that are responsible for multiple points (tokens) in the ring.

Advantages:
- When a node fails, the work is distributed evenly across the other nodes.
- When a node becomes available, it accepts roughly equal amount of work from the existing nodes.
- Based on the capacity of the node, it can be assigned a number of virtual nodes, which helps in achieving heterogeneity.

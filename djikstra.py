def find_lowest_cost_node(costs):
	lowest_cost = float("inf")
	lowest_cost_node = None
	for node in costs:
		cost = costs[node]
		if cost < lowest_cost and node not in processed:
			lowest_cost = cost
			lowest_cost_node = node
	return lowest_cost_node

def dijkstra(costs):
	#Find the node with the least overhead among the unprocessed nodes

	node = find_lowest_cost_node(costs)

	#This while loop ends after all nodes have been processed
	while node is not None:
		cost = costs[node]
		neighbors = graph[node]

		#Traverse all neighbors of the current node
		for n in neighbors.keys():
			new_cost = cost + neighbors[n]
			
			#If the current node goes to the neighbor closer
			if costs[n] > new_cost:
				#Update the neighbor's cost
				costs[n] = new_cost
				#At the same time, set the neighbor's parent node as the current node
				parents[n] = node
		#Mark the current node as processed
		processed.append(node)
		Explode the next node to be processed&#xff0c; and loop
		node = find_lowest_cost_node(costs)


graph = {}
graph["start"] = {}
graph["start"]["a"] = 6
graph["start"]["b"] = 2

# print(graph.values())
# print(graph.keys())
# print(graph.items())
# print(graph)
# print()
# print(graph["start"].values())
# print(graph["start"].keys())
# print(graph["start"].items())
# print(graph["start"])
# print(graph["start"]["a"])

graph["a"] = {}
graph["a"]["fin"] = 1

graph["b"] = {}
graph["b"]["a"] = 3
graph["b"]["fin"] = 5

graph["fin"] = {}
print("{}:{}".format("initial graph",graph))

infinity = float("inf")

#Create cost table
costs = {}
costs["a"] = 6
costs["b"] = 2
costs["fin"] = infinity
print("{}:{}".format("initial costs",costs))

#Create a hash table that stores the parent node
parents = {}
parents["a"] = "start"
parents["b"] ="start"
parents["fin"] = None
print("{}:{}".format("initial parents",parents))

#Record processed nodes
processed = []
dijkstra(costs)
print()
print("{}:{}".format("final costs",costs))
print("{}:{}".format("final parents",parents))

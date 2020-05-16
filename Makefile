NVCC = nvcc
compile: src/dijkstra.cu
	${NVCC} -o dijkstra src/dijkstra.cu
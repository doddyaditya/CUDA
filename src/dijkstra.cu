#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <time.h>
#include <assert.h>

__device__ int minDistance(int dist[], int sptSet[], int V)
{
	// Initialize min value
	int min = INT_MAX, min_index;
	for (int v = 0; v < V; v++)
		if (sptSet[v] == 0 && dist[v] <= min)
			min = dist[v], min_index = v;

	return min_index;
}
__global__ void dijkstra(int *graph, int V,int* ansArray)
{
	int nodes = blockDim.x * blockIdx.x + threadIdx.x;
	if(nodes<V)
	{	int dist[3000]; // The output array. dist[i] will hold the shortest
		// distance from src to i

		int sptSet[3000]; // sptSet[i] will be true if vertex i is included in shortest
		// path tree or shortest distance from src to i is finalized

		// Initialize all distances as INFINITE and stpSet[] as false
		for (int i = 0; i < V; i++)
			dist[i] = INT_MAX, sptSet[i] = 0;

		// Distance of source vertex from itself is always 0
		dist[nodes] = 0;

		// Find shortest path for all vertices
		for (int count = 0; count < V - 1; count++)
		{
			// Pick the minimum distance vertex from the set of vertices not
			// yet processed. u is always equal to src in the first iteration.

			int u = minDistance(dist, sptSet, V);

			// Mark the picked vertex as processed
			sptSet[u] = 1;

			// Update dist value of the adjacent vertices of the picked vertex.
			for (int v = 0; v < V; v++)

				// Update dist[v] only if is not in sptSet, there is an edge from
				// u to v, and total weight of path from src to v through u is
				// smaller than current value of dist[v]
				if (!sptSet[v] && graph[u*V+v] && dist[u] != INT_MAX && dist[u] + graph[u*V+v] < dist[v])
					dist[v] = dist[u] + graph[u*V+v];
		}
		for (int i = 0; i < V; i++)
		{
			ansArray[nodes*V+i] = dist[i];
		}
	}
}
__host__ int* initGraf(int n)
{
	srand(13517143);
	int random;
	int *graf=(int *)malloc(n*n* sizeof(int ));
	for (int i = 0; i < n; i++)
	{
		for (int j = i; j < n; j++)
		{
			random = rand() % 100;
			if (i == j)
			{
				graf[i*n + j] = 0;
			}
			else
			{
				graf[i*n + j] = random;
				graf[j*n + i] = random;
			}
		}
	}
	return graf;
}

int main(int argc, char *argv[])
{
	int thread_count = strtol(argv[1], NULL, 10);
	int node_count = strtol(argv[2],NULL,10);
	int *graf,*answerMatrix,*deviceGraf,*deviceResult;
	graf= initGraf(node_count);
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	answerMatrix= (int *)malloc(node_count *node_count* sizeof(int));
	cudaMalloc(&deviceGraf,node_count*node_count*sizeof(int));
	cudaMalloc(&deviceResult,node_count*node_count*sizeof(int));
	cudaMemcpy(deviceGraf, graf, node_count*node_count*sizeof(int), cudaMemcpyHostToDevice);
	cudaEventRecord(start);

	dijkstra<<<(node_count/thread_count)+1,thread_count>>>(deviceGraf,node_count,deviceResult);
	cudaEventRecord(stop);


	cudaMemcpy(answerMatrix, deviceResult, node_count*node_count*sizeof(int), cudaMemcpyDeviceToHost);
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
	printf("Time elapsed = %f microseconds\n",milliseconds*100);
	printf("Answer Graf\n");

	for (int i = 0; i < node_count; i++) {
		for (int j = 0; j < node_count; j++) 
		  printf("%d\t", answerMatrix[i*node_count + j]);
		printf("\n");
	  }
	
	cudaFree(deviceResult);
	cudaFree(deviceGraf);


	
}

# I. Petunjuk penggunaan program
    nvcc dijkstra.cu -o [executable program name]
    ./[executable program name] [thread] [node]
    
# II. Laporan pengerjaan
1.  Deskripsi solusi paralel<br/>
    Solusi dilakukan dengan menjalankan algoritma dijkstra untuk satu node dengan menggunakan satu thread, misalkan pada kode program kami menggunakan
    128 thread maka pada 1 block akan terdapat 128 thread dengan setiap thread-nya akan menjalankan dijkstra untuk satu node.

2.  Analisis solusi<br/>
    Solusi yang digunakan adalah dengan membagi sejumlah n node ke dalam n thread, maksudnya adalah setiap thread akan mengeksekusi algoritma
    dijkstra untuk setiap node-nya.

3.  Jumlah thread yang digunakan<br/> 
    Jumlah thread yang disarankan untuk digunakan adalah 128 berdasarkan CUDA manuals, hal ini dikarenakan jumlah thread ideal dipengaruhi oleh maximum number of active threads, number of warp schedulers, number of active blocks per streaming multiprocessors.

4.  Pengukuran kinerja untuk tiap kasus uji (jumlah N pada graf) dibandingkan dengan dijkstra algorithm serial<br/>
    1. Node 100 :
     *  Serial : 3894.854248 microseconds
     *  Paralel 1 : 3915.980957 microseconds
     *  Paralel 2 : 3899.795166 microseconds
     *  Paralel 3 : 3906.579102 microseconds
    2. Node 500 :
     *  Serial : 175901.703125 microseconds
     *  Paralel 1 : 128096.218750 microseconds
     *  Paralel 2 : 127824.851562 microseconds
     *  Paralel 3 : 127813.062500 microseconds
    3. Node 1000 :
     *  Serial : 1422463.500000 microseconds
     *  Paralel 1 : 561826.125000 microseconds
     *  Paralel 2 : 567278.000000 microseconds
     *  Paralel 3 : 565658.625000 microseconds
    4. Node 3000 :
     *  Serial : 36696864.000000 microseconds
     *  Paralel 1 : 5139011.500000 microseconds
     *  Paralel 2 : 5176279.500000 microseconds
     *  Paralel 3 : 5017963.500000 microseconds

5.  Analisis perbandingan kinerja serial dan paralel<br/>
    Berdasarkan hasil kasus uji menunjukkan bahwa algoritma paralel yang diterapkan menggunakan CUDA lebih cepat <br/> 
    dibandingkan dengan algoritma secara serial.

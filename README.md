<p align="center">
  Repository of Several Notable Dynamic Programming Based Similarity Measure Algorithms </p>
<h1> DP-Dist </h1>   <br/> 

In this library of **Dynamic Programming Based Similarity Measure Algorithms**, we are trying to implement several notable algorithms for the calculation of the distance between two-time series or vectors or signals. This library is completely open-source and can be used for scientific and academic purposes.

A semple matlab code is shown in the following file, which depicts the use of various algorithms. Please see following file : 
```matlab
-- Simple_UCR_Test.m
```
These algorithms can be applied for the calculation of similarity (distance) between any two time series. Here, we have shown the examples by using the popularly known **UCR Time Series Classification Archive**
The archive can be downloaded from : https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/

<br/>

<h2> Acknowledgments </h2>

We highly thank Prof. Eamonn Keogh, his collegues and numerous people who have contributed to the UCR time series classification archive for their numerous hours of selfless work. Plese visit the following link for more details on the archive : 
https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/BriefingDocument2018.pdf

</br>

Following is the list of algorithms, which are implemented in this library :

<h3> 1.  &nbsp; Dynamic Time Warping (DTW) </h3>
<br/>
<div style="padding-left: 30px;">
Dynamic Time Warping (DTW) is a highly popular technique for measuring similarity between two different time series by finding their best correspondence.  
</div>
<br/>
<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Ratanamahatana, C., & Keogh, E. (2004). Everything you know about dynamic time warping is wrong. Third Workshop on Mining Temporal and Sequential Data, 22–25.`

<br/>
<div style="padding-left: 30px;">
The implementation can be found in :
</div>


```matlab
- DynamicTimeWarping(Data_Ref,Data_Target)
```


<h3> 2. &nbsp; Derivative Dynamic Time Warping (DDTW) </h3>
<br/>
<div style="padding-left: 30px;">
	The typical condition of classical DTW may lead to unexpected singularities (the alignments between a point of a series with multiple points of the other series) and unintuitive alignments. To overcome these weaknesses of DTW, DDTW transforms the original points into higher level features, which contain the structural information of the signal. This technique considers the first derivative of the signals instead of original signals.  
</div>
<br/>

<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Eamonn J. Keogh, M. J. P. (2000). Scaling up dynamic time warping for datamining applications. KDD, 285–289.`

<br/>
<div style="padding-left: 30px;">
The implementation can be found in :
</div>


```matlab
- Derivative_DynamicTimeWarping(Data_Ref,Data_Target)
```


<h3> 3.  &nbsp; Value Derivative Dynamic Time Wapring (VDDTW) </h3>
<br/>
<div style="padding-left: 30px;">
Standard DTW uses Euclidean metric for calculating the distance between the elements of target and query sequences. This distance is good to compare single points but not appropriate for comparing the vector sequences. One more intelligent way to calculate the distance is by giving consideration to  adjacent values of time series, which is sensitive on the local changes among time series elements.
</div>
<br/>

<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Kulbacki, M., Kulbacki, M., Segen, J., Segen, J., Bak, A., & Bak, A. (2002). Unsupervised Learning Motion Models Using Dynamic Time Warping. Systems Research, July 2015, 1–10.`

<br/>
<div style="padding-left: 30px;">
The implementation can be found in :
</div>


```matlab
- ValueDerivative_DTW(Data_Ref,Data_Target)
```

<h3> 4.  &nbsp; Weighted Hybrid Dynamic Time Wapring (WHDTW) </h3>
<br/>
<div style="padding-left: 30px;">
The information from raw signal contains useful information and smoothing the raw signal helps to stabilize the process. Moreover, the derivative provides better knowledge. For example, the first derivative gives information on speed and the second derivative gives information on accelerations and decelerations. To handle the noise sensitiveness of DDTW, int this algorithm, the distance matrix is computed in different manner.  
</div>
<br/>

<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Benedikt, L., Kajic, V., Cosker, D., Rosin, P. L., & Marshall, D. (2008). 
Facial Dynamics in Biometric Identification. Proceedings of the British Machine Vision Conference.`

<br/>
<div style="padding-left: 30px;">
The implementation can be found in :
</div>


```matlab
- WeightedHybrid_DTW(Data_Ref,Data_Target)
```

<h3> 5.  &nbsp; Non Isometric Transform Based Dynamic Time Wapring  </h3>
<br/>
<div style="padding-left: 30px;">
  In this algorithm, the authors proposed to use mathematical functions other than the derivative, to transform the signals. The idea is to choose some non-isometric transforms to calculate distances, which can bring some extra information, which seems to be useful in the domain of sequence matching. 
	The authors have proposed to use following three popular non isometric transforms : 
</div>
<br/>

<h4> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5.1 &nbsp; Sine Transform : </h4>
<p align="center">
  <img  width="310" src="imgs/sin.png">
</p>

<h4> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5.2 &nbsp; Cosine Transform : </h4>
<p align="center">
  <img  width="310" src="imgs/cosine.png">
</p>
<h4> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5.3 &nbsp; Hilbert transform : </h4>
<p align="center">
  <img  width="150" src="imgs/hilbert.png">
</p>

 
  
<div style="padding-left: 30px;">
For more details, see : 
</div>


- `Górecki, T., & Luczak, M. (2014). Non-isometric transforms in time series classification using DTW. Knowledge-Based Systems, 61, 98–108. `

<br/>
<div style="padding-left: 30px;">
The implementation can be found in :
</div>


```matlab
- IsometricTransformDTW(Data_Ref,Data_Target,methodName)
```
<br/>
<h3> 6.  &nbsp; Weighted Dynamic Time Warping (WDTW)  </h3>
<br/>
<div style="padding-left: 30px;">
    The standard DTW calculates the distance of all points with equal penalization of each point regardless of the phase difference (different time indices). The WDTW algorithm penalizes the points according to the phase difference between target and query elements to prevent minimum distance distortion by outliers. The key idea is that, if the phase difference is low, smaller weight is imposed (i.e. less penalty is imposed) because neighboring points are important, otherwise larger weight is used. 
</div>
<br/>
<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Jeong, Y. S., Jeong, M. K., & Omitaomu, O. A. (2011). Weighted dynamic time warping for time series classification. Pattern Recognition, 44(9), 2231–2240.`

<br/>
<div style="padding-left: 30px;">
The implementation can be found in :
</div>


```matlab
- WeightedDynamicTimeWarping(refSample,testSample,tip)
```
<br/>
<h3> 7.  &nbsp; Weighted Derivative Dynamic Time Warping (WDDTW)  </h3>
<br/>
<div style="padding-left: 30px;">
  The idea of weighted dynamic time warping can be extended to variants of DTW, for example the idea of derivative dynamic time warping can be extended to it's weighted version, which is named as Weighted Derivative Dynamic Time Warping (WDDTW).	 
</div>
<br/>
<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Jeong, Y. S., Jeong, M. K., & Omitaomu, O. A. (2011). Weighted dynamic time warping for time series classification. Pattern Recognition, 44(9), 2231–2240.`
<br/>
<div style="padding-left: 30px;">
<br/>
The implementation can be found in :
</div>


```matlab
- Weighted_Derivative_DynamicTimeWarping(Data_Ref,Data_Target,tip)
```

<br/>
<h3> 8.  &nbsp; Piecewise DTW (PDTW)  </h3>
<br/>
<div style="padding-left: 30px;">
	Most time series data can be efficiently approximated by piecewise aggregates, so that DTW can operate on higher level of data. The main idea of PDTW is to reduce the size of original signal by capturing the significant representations of the full signal through sub-sampling technique.  
</div>
<br/>
<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Eamonn J. Keogh, M. J. P. (2000). Scaling up dynamic time warping for datamining applications. KDD, 285–289.`
<br/>

<div style="padding-left: 30px;">
<br/>
The implementation can be found in :
</div>


```matlab
- PAA_PDTW(Data_Ref,Data_Target,avgWidth)
```

<br/>
<h3> 9.  &nbsp; Piecewise Derivative DTW (PDDTW)  </h3>
<br/>
<div style="padding-left: 30px;">
  The Piecewise Derivative Dynamic Time Warping (PDDTW), uses at the same time the derivative of the signal in order to reduce singularities and data abstraction for capturing the benefits of both PDTW and DDTW together. In order to align two sequences X and Y, a reduced dimensional series are obtained first. Then the **DDTW** on these reduced dimensional time series.
</div>
<br/>
<div style="padding-left: 30px;">
For more details, see : 
</div>

- `Zifan, A., Saberi, S., Moradi, M. H., & Towhidkhah, F. (2007). Automated ECG Segmentation Using Piecewise Derivative Dynamic Time Warping. International Journal of Medical, Health, Pharmaceutical and Biomedical Engineering, 1(3), 764–768.`
<br/>

<div style="padding-left: 30px;">
<br/>
The implementation can be found in :
</div>


```matlab
- PeicewiseDerivative_DynamicTimeWarping(Data_Ref,Data_Target,avgWidth)
```

<br/>
<h3> 10.  &nbsp; Subsequence DTW (SSDTW)  </h3>
<br/>
<div style="padding-left: 30px;">
  This algorithm can find a continuous subsequence that would optimally match the shorter query sequence.
</div>
<br/>
<div style="padding-left: 30px;">
<br/>
For more details, see : 
</div>

- `Albrecht, T. (2009). Dynamic Time Warping (DTW). 69–85.`
<br/>

<div style="padding-left: 30px;">
<br/>
The implementation can be found in :
</div>


```matlab
- SubsequenceDynamicTimeWarping(refSample,testSample)
```

<br/>
<h3> 11.  &nbsp; Meshesha-Jawahar DTW (MJ-DTW)  </h3>
<br/>
<div style="padding-left: 30px;">
  When targets that differ from reference, in terms of prefixes and suffixes, the warping path can deviate (from diagonal) in horizontal or in vertical directions at the beginning or at end. Such situation can significantly increases the matching cost and can disturb the matching for the corresponding part of the target and reference signals. To avoid such behavior, a DTW based partial sequence matching technique, dedicated to word spotting, for handling the variations at the beginning and at the end of the sequences. To reduce unwanted extra cost, MJ-DTW first analyzes whether the dissimilarity between words is concentrated at the end, at the beginning or both. Then, the extra cost at the two extremes are removed to reduce the total matching score and to obtain the optimal dissimilarity value.
</div>
<br/>
<div style="padding-left: 30px;">
<br/>
For more details, see : 
</div>

- `Meshesha, M., & Jawahar, C. V. (2008). Matching word images for content-based retrieval from printed document images. IJDAR, 11(1), 29–38.`
<br/>

<div style="padding-left: 30px;">
<br/>
The implementation can be found in :
</div>


```matlab
- DTW_Jahawar(refSample,testSample)
```

<br/>
<h3> 12.  &nbsp; DTW with Correspondence Window (DTW-CW)  </h3>
<br/>
<div style="padding-left: 30px;">
  When a query sequence has to be matched with a subsequence of a target sequence, the matching can be performed by using a sliding correspondence window, having same length as query, and an overlapping. The position of optimal subsequence within the target sequence is obtained by calculating DTW distance inside each window position over a query sequence. Consequently, DTW-CW is computationally expensive and choosing the overlapping parameter could also be troublesome for some applications. 
</div>
<br/>
<div style="padding-left: 30px;">
<br/>
For more details, see : 
</div>

- `Latecki, L. J., Koknar-tezel, S., Wang, Q., & Megalooikonomou, V. (2007). Sequence Matching Capable of Excluding Outliers. Int. Conf. on Knowledge Discovery and Data Mining (KDD).`
<br/>

<div style="padding-left: 30px;">
<br/>
The implementation can be found in :
</div>


```matlab
- DynamicTimeWarping_CW(refSample,testSample,avgCharWidth)
```
<br/>

<h3> 13.  &nbsp; Longest Common Sub-sequence (LCSS)  </h3>
<br/>
<div style="padding-left: 30px;">
	The Longest Common Subsequence dissimilarity measure is an algorithm based on Edit Distance or Levenshtein Distance. 
	The basic idea is to match corresponding elements, keeping the order and allowing some elements to be unmatched or left out (e.g. outliers).
	The LCSS measure has two parameters. 
	The first constant is usually needed set to a percentage of the sequence length, which is a constrained window size for matching a given point from one sequence to a point in another sequence. 
	It controls how far in time, we can go in order to match a given point from one trajectory to a point in another trajectory. 
	The second constant is the matching threshold: two points from two sequences can be matched, if their distance is less than a given threshold. 
	The performance of LCSS highly depends on the correct setting of this threshold, which may be a difficult problem for some applications.
  By considering the ratio between length of the calculated longest common subsequence and that of whole sequence, the dissimilarity between query and target sequence is calculated. Since the inherent goal of finding longest common subsequence is to find optimal substructure between two compared sequences, the problem of LCSS is often solved with dynamic programming.  
</div>
<br/>
---
title: Assignment 1
subtitle: Computer performance, reliability, and scalability calculation
author: Kimberly Cable
---

## 1.2 

#### a. Data Sizes

| Data Item                                  | Size per Item | 
|--------------------------------------------|--------------:|
| 128 character message.                     | 128 Bytes     |
| 1024x768 PNG image                         | 0.031985 MB   |
| 1024x768 RAW image                         | 1.57 MB       | 
| HD (1080p) HEVC Video (15 minutes)         | 878.9 MB      |
| HD (1080p) Uncompressed Video (15 minutes) | 160180.66 MB  |
| 4K UHD HEVC Video (15 minutes)             | 5062.5 MB     |
| 4k UHD Uncompressed Video (15 minutes)     | 40500 MB      |
| Human Genome (Uncompressed)                | 0.8 GB        |

1 character = 1 byte => 128 char = 128 bytes

PNG: RGBA_8, default Z Compression: Created test PNG file in inkscape<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(depends on 8 color vs 16 color and image)

RAW: 16bit monochrome (toolstud.io)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(depends on 12, 14, or 16bit)

HD HEVC Video: https://www.videoproc.com/edit-4k-video/video-size-calculator.htm
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(MP4 H.265/HEVC)

HD Uncompressed Video: https://www.videoproc.com/edit-4k-video/video-size-calculator.htm
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Uncompressed 1080 8-bit)

HD Uncompressed Video: https://www.videoproc.com/edit-4k-video/video-size-calculator.htm
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(4K H.264)

4K UHD Uncompressed: https://www.videoproc.com/edit-4k-video/video-size-calculator.htm
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(REDCODE36 RAW 4K)

Human Genome: https://www.technologyreview.com/2012/04/25/186381/bases-to-bytes/


#### b. Scaling

|                                           | Size     |  # HD | 
|-------------------------------------------|---------:|------:|
| Daily Twitter Tweets (Uncompressed)       | 64 GB    |  1    |
| Daily Twitter Tweets (Snappy Compressed)  | 42.67 GB |  1    |
| Daily Instagram Photos                    | 2.40 TB  |  1    |
| Daily YouTube Videos                      | 42.19 TB |  13   |
| Yearly Twitter Tweets (Uncompressed)      | 23.36 TB |  8    |
| Yearly Twitter Tweets (Snappy Compressed) | 15.57 TB |  5    |
| Yearly Instagram Photos                   | 876 TB   |  263  |
| Yearly YouTube Videos                     | 15399 TB |  1540 |


Twitter (uncompressed): 500000000 tweets * 128 char/tweet * 1 byte/char<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (64 GB * 3) * 1 TB / 1000 GB * 1 HD / 10 TB

Twitter (snappy): 1.5X Compression<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (42.67 GB * 3) * 1 TB / 1000 GB * 1 HD / 10 TB

Instagram Photos: 100,000,000 daily * 0.75 PNGs * 0.031985 MB / PNG * 1 TB / 1,000,000 MB<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (2.4 TB * 3) * 1 HD / 10 TB

YouTube: 500 hrs/min * 1440 min/day * 878.9 MB / 15 min * 1 TB / 100000 MB <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (42.19 TB * 3) * 1 HD / 10 TB

Years Twitter (uncompressed):  64 GB / day * 365 days / yr * 1 TB / 1000 GB<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (23.36 TB * 3) * 1 HD / 10 TB

Years Twitter (snappy):  42.67 GB / day * 365 days / yr * 1 TB / 1000 GB<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (15.57 TB * 3) * 1 HD / 10 TB

Yearly Instagram Photos: 2.4 TB / day * 365 days / yr<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (876 TB * 3) * 1 HD / 10 TB

Yearly YouTube: 42.19 TB / day * 365 days / yr<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hard Drive: (15399 TB * 3) * 1 HD / 10 TB

#### c. Reliability
|                                    | # HD | # Failures |
|------------------------------------|-----:|-----------:|
| Twitter Tweets (Uncompressed)      |  8   |     ~ 1    |
| Twitter Tweets (Snappy Compressed) |  5   |     ~ 1    |
| Instagram Photos                   | 263  |     ~ 5    |
| YouTube Videos                     | 1540 |    ~ 26    |

Annualized failure rate of a drive is 1.64%

#### d. Latency

|                           | One Way Latency      |
|---------------------------|---------------------:|
| Los Angeles to Amsterdam  | 44.67 ms             |
| Low Earth Orbit Satellite | 4.5 ms              |
| Geostationary Satellite   | 178.93 ms            |
| Earth to the Moon         | 1922 ms              |
| Earth to Mars             | 6.94 minutes         | 

https://blog.scaleway.com/understanding-network-latency/: 5 ms per 1000 km one-way

LA to Amsterdam: 8,934 kn * 5 ms / 1000 km

Low Earth: 900 km (avg) * 5 ms / 1000 km

Geostationary: 35,786 km * 5 ms / 1000 km

Earth to Moon: 384,400 km * 5 ms / 1000 km

Earth to Mars: 83.336 mil km * 5 ms / 1000 km * 1 min / 60000 secs
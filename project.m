%{
    ECE 4553 - Introduction to Pattern Recognition Term Project Code
    Student : Burak KORYAN
    Date : December 4 2017
    Instructor : Dr.Erik Scheme
    Description : The source code below is for classification of
    handwriting samples by gender.Overall structure of code is given below:

    1) Pre-Processing
          a.Sample word cropping using MATLAB
          b.RGB to grayscale image conversion
          c.Converting images into binary

    2) Feature extraction:
         d.Entropy calculation
         e.Calculating percentage of black pixels above horizontal
         half-point of image
    
    3) Classification 
        f. Classification using LDA
        h. Classification using QDA
        g. Classification using kNN (with different k values)
        h. Classification using Naive Bayes
%}

clc;

%% Sample filename list for male & female:
class = {'A','B','E','G','H','K','M','P','JESUS','LOVES','YOU','TIME','UNFORGIVEN'.....
        'ELEPHANT','TRANSPARENT','IS','GREEN','MATH','STOP','MONEY','JFK','MOUSE','BRAZIL'....
        'APPLE','MOOSE','DEER','COOL','JACKET'};

Sample_females = {'1.tif','2.tif','3.tif','4.tif','5.tif','6.tif','7.tif'....
           '8.tif','9.tif','10.tif','11.tif','12.tif','13.tif','14.tif'....
           '15.tif','16.tif','17.tif','18.tif','19.tif','20.tif','21.tif'....
           '22.tif','23.tif','24.tif','25.tif','26.tif','27.tif','28.tif'....
           '29.tif','30.tif','31.tif','32.tif','33.tif','34.tif','35.tif'....
           '36.tif','37.tif','38.tif','39.tif','40.tif','41.tif','42.tif'....
           '43.tif','44.tif','45.tif','46.tif','47.tif','48.tif','49.tif',....
           '50.tif','51.tif','52.tif','53.tif','54.tif','55.tif','56.tif'};
       
Sample_males = {'63.tif','64.tif','65.tif','66.tif','67.tif','68.tif','69.tif'....
           '70.tif','71.tif','72.tif','73.tif','74.tif','75.tif','76.tif'....
           '77.tif','78.tif','79.tif','80.tif','81.tif','82.tif','83.tif'....
           '84.tif','85.tif','86.tif','87.tif','88.tif','89.tif','90.tif'....
           '91.tif','92.tif','93.tif','94.tif','95.tif','96.tif','97.tif'....
           '98.tif','99.tif','111.tif','112.tif','113.tif','114.tif'};
          
Sample_female_jpg = {'1.jpg','2.jpg','3.jpg','4.jpg','5.jpg','6.jpg','7.jpg'....
                      '8.jpg','9.jpg','10.jpg','11.jpg','12.jpg','13.jpg','14.jpg'....
                      '15.jpg','16.jpg','17.jpg','18.jpg','19.jpg','20.jpg','21.jpg'....
                      '22.jpg','23.jpg','24.jpg','25.jpg','26.jpg','27.jpg','28.jpg'....
                      '29.jpg','30.jpg','31.jpg','32.jpg','33.jpg','34.jpg','35.jpg'....
                      '36.jpg','37.jpg','38.jpg','39.jpg','40.jpg','41.jpg','42.jpg'....
                      '43.jpg','44.jpg','45.jpg','46.jpg','47.jpg','48.jpg','49.jpg',....
                      '50.jpg','51.jpg','52.jpg','53.jpg','54.jpg','55.jpg','56.jpg'};          

Sample_male_jpg = {'63.jpg','64.jpg','65.jpg','66.jpg','67.jpg','68.jpg','69.jpg'....
    '70.jpg','71.jpg','72.jpg','73.jpg','74.jpg','75.jpg','76.jpg'....
    '77.jpg','78.jpg','79.jpg','80.jpg','81.jpg','82.jpg','83.jpg'....
    '84.jpg','85.jpg','86.jpg','87.jpg','88.jpg','89.jpg','90.jpg'....
    '91.jpg','92.jpg','93.jpg','94.jpg','95.jpg','96.jpg','97.jpg'....
    '98.jpg','99.jpg','111.jpg','112.jpg','113.jpg','114.jpg'};
          

% Female Sample Headers:     
Sample_female_A1tif = {'F_A1.tif','F_A2.tif','F_A3.tif','F_A4.tif','F_A5.tif','F_A6.tif','F_A7.tif'....
           'F_A8.tif','F_A9.tif','F_A10.tif','F_A11.tif','F_A12.tif','F_A13.tif','F_A14.tif'....
           'F_A15.tif','F_A16.tif','F_A17.tif','F_A18.tif','F_A19.tif','F_A20.tif','F_A21.tif'....
           'F_A22.tif','F_A23.tif','F_A24.tif','F_A25.tif','F_A26.tif','F_A27.tif','F_A28.tif'....
           'F_A29.tif','F_A30.tif','F_A31.tif','F_A32.tif','F_A33.tif','F_A34.tif','F_A35.tif'....
           'F_A36.tif','F_A37.tif','F_A38.tif','F_A39.tif','F_A40.tif','F_A41.tif','F_A42.tif'....
           'F_A43.tif','F_A44.tif','F_A45.tif','F_A46.tif','F_A47.tif','F_A48.tif','F_A49.tif',....
           'F_A50.tif','F_A51.tif','F_A52.tif','F_A53.tif','F_A54.tif','F_A55.tif','F_A56.tif'};   
       
Sample_female_Btif = {'F_B1.tif','F_B2.tif','F_B3.tif','F_B4.tif','F_B5.tif','F_B6.tif','F_B7.tif'....
           'F_B8.tif','F_B9.tif','F_B10.tif','F_B11.tif','F_B12.tif','F_B13.tif','F_B14.tif'....
           'F_B15.tif','F_B16.tif','F_B17.tif','F_B18.tif','F_B19.tif','F_B20.tif','F_B21.tif'....
           'F_B22.tif','F_B23.tif','F_B24.tif','F_B25.tif','F_B26.tif','F_B27.tif','F_B28.tif'....
           'F_B29.tif','F_B30.tif','F_B31.tif','F_B32.tif','F_B33.tif','F_B34.tif','F_B35.tif'....
           'F_B36.tif','F_B37.tif','F_B38.tif','F_B39.tif','F_B40.tif','F_B41.tif','F_B42.tif'....
           'F_B43.tif','F_B44.tif','F_B45.tif','F_B46.tif','F_B47.tif','F_B48.tif','F_B49.tif',....
           'F_B50.tif','F_B51.tif','F_B52.tif','F_B53.tif','F_B54.tif','F_B55.tif','F_B56.tif'};     

Sample_female_Etif = {'F_E1.tif','F_E2.tif','F_E3.tif','F_E4.tif','F_E5.tif','F_E6.tif','F_E7.tif'....
           'F_E8.tif','F_E9.tif','F_E10.tif','F_E11.tif','F_E12.tif','F_E13.tif','F_E14.tif'....
           'F_E15.tif','F_E16.tif','F_E17.tif','F_E18.tif','F_E19.tif','F_E20.tif','F_E21.tif'....
           'F_E22.tif','F_E23.tif','F_E24.tif','F_E25.tif','F_E26.tif','F_E27.tif','F_E28.tif'....
           'F_E29.tif','F_E30.tif','F_E31.tif','F_E32.tif','F_E33.tif','F_E34.tif','F_E35.tif'....
           'F_E36.tif','F_E37.tif','F_E38.tif','F_E39.tif','F_E40.tif','F_E41.tif','F_E42.tif'....
           'F_E43.tif','F_E44.tif','F_E45.tif','F_E46.tif','F_E47.tif','F_E48.tif','F_E49.tif',....
           'F_E50.tif','F_E51.tif','F_E52.tif','F_E53.tif','F_E54.tif','F_E55.tif','F_E56.tif'};      
       
Sample_female_Gtif = {'F_G1.tif','F_G2.tif','F_G3.tif','F_G4.tif','F_G5.tif','F_G6.tif','F_G7.tif'....
           'F_G8.tif','F_G9.tif','F_G10.tif','F_G11.tif','F_G12.tif','F_G13.tif','F_G14.tif'....
           'F_G15.tif','F_G16.tif','F_G17.tif','F_G18.tif','F_G19.tif','F_G20.tif','F_G21.tif'....
           'F_G22.tif','F_G23.tif','F_G24.tif','F_G25.tif','F_G26.tif','F_G27.tif','F_G28.tif'....
           'F_G29.tif','F_G30.tif','F_G31.tif','F_G32.tif','F_G33.tif','F_G34.tif','F_G35.tif'....
           'F_G36.tif','F_G37.tif','F_G38.tif','F_G39.tif','F_G40.tif','F_G41.tif','F_G42.tif'....
           'F_G43.tif','F_G44.tif','F_G45.tif','F_G46.tif','F_G47.tif','F_G48.tif','F_G49.tif',....
           'F_G50.tif','F_G51.tif','F_G52.tif','F_G53.tif','F_G54.tif','F_G55.tif','F_G56.tif'};   
   

Sample_female_Htif = {'F_H1.tif','F_H2.tif','F_H3.tif','F_H4.tif','F_H5.tif','F_H6.tif','F_H7.tif'....
           'F_H8.tif','F_H9.tif','F_H10.tif','F_H11.tif','F_H12.tif','F_H13.tif','F_H14.tif'....
           'F_H15.tif','F_H16.tif','F_H17.tif','F_H18.tif','F_H19.tif','F_H20.tif','F_H21.tif'....
           'F_H22.tif','F_H23.tif','F_H24.tif','F_H25.tif','F_H26.tif','F_H27.tif','F_H28.tif'....
           'F_H29.tif','F_H30.tif','F_H31.tif','F_H32.tif','F_H33.tif','F_H34.tif','F_H35.tif'....
           'F_H36.tif','F_H37.tif','F_H38.tif','F_H39.tif','F_H40.tif','F_H41.tif','F_H42.tif'....
           'F_H43.tif','F_H44.tif','F_H45.tif','F_H46.tif','F_H47.tif','F_H48.tif','F_H49.tif',....
           'F_H50.tif','F_H51.tif','F_H52.tif','F_H53.tif','F_H54.tif','F_H55.tif','F_H56.tif'};   

Sample_female_Ktif = {'F_K1.tif','F_K2.tif','F_K3.tif','F_K4.tif','F_K5.tif','F_K6.tif','F_K7.tif'....
           'F_K8.tif','F_K9.tif','F_K10.tif','F_K11.tif','F_K12.tif','F_K13.tif','F_K14.tif'....
           'F_K15.tif','F_K16.tif','F_K17.tif','F_K18.tif','F_K19.tif','F_K20.tif','F_K21.tif'....
           'F_K22.tif','F_K23.tif','F_K24.tif','F_K25.tif','F_K26.tif','F_K27.tif','F_K28.tif'....
           'F_K29.tif','F_K30.tif','F_K31.tif','F_K32.tif','F_K33.tif','F_K34.tif','F_K35.tif'....
           'F_K36.tif','F_K37.tif','F_K38.tif','F_K39.tif','F_K40.tif','F_K41.tif','F_K42.tif'....
           'F_K43.tif','F_K44.tif','F_K45.tif','F_K46.tif','F_K47.tif','F_K48.tif','F_K49.tif',....
           'F_K50.tif','F_K51.tif','F_K52.tif','F_K53.tif','F_K54.tif','F_K55.tif','F_K56.tif'};   

Sample_female_Mtif = {'F_M1.tif','F_M2.tif','F_M3.tif','F_M4.tif','F_M5.tif','F_M6.tif','F_M7.tif'....
           'F_M8.tif','F_M9.tif','F_M10.tif','F_M11.tif','F_M12.tif','F_M13.tif','F_M14.tif'....
           'F_M15.tif','F_M16.tif','F_M17.tif','F_M18.tif','F_M19.tif','F_M20.tif','F_M21.tif'....
           'F_M22.tif','F_M23.tif','F_M24.tif','F_M25.tif','F_M26.tif','F_M27.tif','F_M28.tif'....
           'F_M29.tif','F_M30.tif','F_M31.tif','F_M32.tif','F_M33.tif','F_M34.tif','F_M35.tif'....
           'F_M36.tif','F_M37.tif','F_M38.tif','F_M39.tif','F_M40.tif','F_M41.tif','F_M42.tif'....
           'F_M43.tif','F_M44.tif','F_M45.tif','F_M46.tif','F_M47.tif','F_M48.tif','F_M49.tif',....
           'F_M50.tif','F_M51.tif','F_M52.tif','F_M53.tif','F_M54.tif','F_M55.tif','F_M56.tif'}; 
       
Sample_female_Ptif = {'F_P1.tif','F_P2.tif','F_P3.tif','F_P4.tif','F_P5.tif','F_P6.tif','F_P7.tif'....
           'F_P8.tif','F_P9.tif','F_P10.tif','F_P11.tif','F_P12.tif','F_P13.tif','F_P14.tif'....
           'F_P15.tif','F_P16.tif','F_P17.tif','F_P18.tif','F_P19.tif','F_P20.tif','F_P21.tif'....
           'F_P22.tif','F_P23.tif','F_P24.tif','F_P25.tif','F_P26.tif','F_P27.tif','F_P28.tif'....
           'F_P29.tif','F_P30.tif','F_P31.tif','F_P32.tif','F_P33.tif','F_P34.tif','F_P35.tif'....
           'F_P36.tif','F_P37.tif','F_P38.tif','F_P39.tif','F_P40.tif','F_P41.tif','F_P42.tif'....
           'F_P43.tif','F_P44.tif','F_P45.tif','F_P46.tif','F_P47.tif','F_P48.tif','F_P49.tif',....
           'F_P50.tif','F_P51.tif','F_P52.tif','F_P53.tif','F_P54.tif','F_P55.tif','F_P56.tif'};   

Sample_female_jesus = {'F_jesus1.tif','F_jesus2.tif','F_jesus3.tif','F_jesus4.tif','F_jesus5.tif','F_jesus6.tif','F_jesus7.tif'....
           'F_jesus8.tif','F_jesus9.tif','F_jesus10.tif','F_jesus11.tif','F_jesus12.tif','F_jesus13.tif','F_jesus14.tif'....
           'F_jesus15.tif','F_jesus16.tif','F_jesus17.tif','F_jesus18.tif','F_jesus19.tif','F_jesus20.tif','F_jesus21.tif'....
           'F_jesus22.tif','F_jesus23.tif','F_jesus24.tif','F_jesus25.tif','F_jesus26.tif','F_jesus27.tif','F_jesus28.tif'....
           'F_jesus29.tif','F_jesus30.tif','F_jesus31.tif','F_jesus32.tif','F_jesus33.tif','F_jesus34.tif','F_jesus35.tif'....
           'F_jesus36.tif','F_jesus37.tif','F_jesus38.tif','F_jesus39.tif','F_jesus40.tif','F_jesus41.tif','F_jesus42.tif'....
           'F_jesus43.tif','F_jesus44.tif','F_jesus45.tif','F_jesus46.tif','F_jesus47.tif','F_jesus48.tif','F_jesus49.tif',....
           'F_jesus50.tif','F_jesus51.tif','F_jesus52.tif','F_jesus53.tif','F_jesus54.tif','F_jesus55.tif','F_jesus56.tif'};   

Sample_female_loves = {'F_loves1.tif','F_loves2.tif','F_loves3.tif','F_loves4.tif','F_loves5.tif','F_loves6.tif','F_loves7.tif'....
           'F_loves8.tif','F_loves9.tif','F_loves10.tif','F_loves11.tif','F_loves12.tif','F_loves13.tif','F_loves14.tif'....
           'F_loves15.tif','F_loves16.tif','F_loves17.tif','F_loves18.tif','F_loves19.tif','F_loves20.tif','F_loves21.tif'....
           'F_loves22.tif','F_loves23.tif','F_loves24.tif','F_loves25.tif','F_loves26.tif','F_loves27.tif','F_loves28.tif'....
           'F_loves29.tif','F_loves30.tif','F_loves31.tif','F_loves32.tif','F_loves33.tif','F_loves34.tif','F_loves35.tif'....
           'F_loves36.tif','F_loves37.tif','F_loves38.tif','F_loves39.tif','F_loves40.tif','F_loves41.tif','F_loves42.tif'....
           'F_loves43.tif','F_loves44.tif','F_loves45.tif','F_loves46.tif','F_loves47.tif','F_loves48.tif','F_loves49.tif',....
           'F_loves50.tif','F_loves51.tif','F_loves52.tif','F_loves53.tif','F_loves54.tif','F_loves55.tif','F_loves56.tif'};   

Sample_female_you = {'F_you1.tif','F_you2.tif','F_you3.tif','F_you4.tif','F_you5.tif','F_you6.tif','F_you7.tif'....
           'F_you8.tif','F_you9.tif','F_you10.tif','F_you11.tif','F_you12.tif','F_you13.tif','F_you14.tif'....
           'F_you15.tif','F_you16.tif','F_you17.tif','F_you18.tif','F_you19.tif','F_you20.tif','F_you21.tif'....
           'F_you22.tif','F_you23.tif','F_you24.tif','F_you25.tif','F_you26.tif','F_you27.tif','F_you28.tif'....
           'F_you29.tif','F_you30.tif','F_you31.tif','F_you32.tif','F_you33.tif','F_you34.tif','F_you35.tif'....
           'F_you36.tif','F_you37.tif','F_you38.tif','F_you39.tif','F_you40.tif','F_you41.tif','F_you42.tif'....
           'F_you43.tif','F_you44.tif','F_you45.tif','F_you46.tif','F_you47.tif','F_you48.tif','F_you49.tif',....
           'F_you50.tif','F_you51.tif','F_you52.tif','F_you53.tif','F_you54.tif','F_you55.tif','F_you56.tif'};   

Sample_female_time = {'F_time1.tif','F_time2.tif','F_time3.tif','F_time4.tif','F_time5.tif','F_time6.tif','F_time7.tif'....
           'F_time8.tif','F_time9.tif','F_time10.tif','F_time11.tif','F_time12.tif','F_time13.tif','F_time14.tif'....
           'F_time15.tif','F_time16.tif','F_time17.tif','F_time18.tif','F_time19.tif','F_time20.tif','F_time21.tif'....
           'F_time22.tif','F_time23.tif','F_time24.tif','F_time25.tif','F_time26.tif','F_time27.tif','F_time28.tif'....
           'F_time29.tif','F_time30.tif','F_time31.tif','F_time32.tif','F_time33.tif','F_time34.tif','F_time35.tif'....
           'F_time36.tif','F_time37.tif','F_time38.tif','F_time39.tif','F_time40.tif','F_time41.tif','F_time42.tif'....
           'F_time43.tif','F_time44.tif','F_time45.tif','F_time46.tif','F_time47.tif','F_time48.tif','F_time49.tif',....
           'F_time50.tif','F_time51.tif','F_time52.tif','F_time53.tif','F_time54.tif','F_time55.tif','F_time56.tif'};   

Sample_female_unforgiven = {'F_unforgiven1.tif','F_unforgiven2.tif','F_unforgiven3.tif','F_unforgiven4.tif','F_unforgiven5.tif','F_unforgiven6.tif','F_unforgiven7.tif'....
           'F_unforgiven8.tif','F_unforgiven9.tif','F_unforgiven10.tif','F_unforgiven11.tif','F_unforgiven12.tif','F_unforgiven13.tif','F_unforgiven14.tif'....
           'F_unforgiven15.tif','F_unforgiven16.tif','F_unforgiven17.tif','F_unforgiven18.tif','F_unforgiven19.tif','F_unforgiven20.tif','F_unforgiven21.tif'....
           'F_unforgiven22.tif','F_unforgiven23.tif','F_unforgiven24.tif','F_unforgiven25.tif','F_unforgiven26.tif','F_unforgiven27.tif','F_unforgiven28.tif'....
           'F_unforgiven29.tif','F_unforgiven30.tif','F_unforgiven31.tif','F_unforgiven32.tif','F_unforgiven33.tif','F_unforgiven34.tif','F_unforgiven35.tif'....
           'F_unforgiven36.tif','F_unforgiven37.tif','F_unforgiven38.tif','F_unforgiven39.tif','F_unforgiven40.tif','F_unforgiven41.tif','F_unforgiven42.tif'....
           'F_unforgiven43.tif','F_unforgiven44.tif','F_unforgiven45.tif','F_unforgiven46.tif','F_unforgiven47.tif','F_unforgiven48.tif','F_unforgiven49.tif',....
           'F_unforgiven50.tif','F_unforgiven51.tif','F_unforgiven52.tif','F_unforgiven53.tif','F_unforgiven54.tif','F_unforgiven55.tif','F_unforgiven56.tif'};   

Sample_female_elephant = {'F_elephant1.tif','F_elephant2.tif','F_elephant3.tif','F_elephant4.tif','F_elephant5.tif','F_elephant6.tif','F_elephant7.tif'....
           'F_elephant8.tif','F_elephant9.tif','F_elephant10.tif','F_elephant11.tif','F_elephant12.tif','F_elephant13.tif','F_elephant14.tif'....
           'F_elephant15.tif','F_elephant16.tif','F_elephant17.tif','F_elephant18.tif','F_elephant19.tif','F_elephant20.tif','F_elephant21.tif'....
           'F_elephant22.tif','F_elephant23.tif','F_elephant24.tif','F_elephant25.tif','F_elephant26.tif','F_elephant27.tif','F_elephant28.tif'....
           'F_elephant29.tif','F_elephant30.tif','F_elephant31.tif','F_elephant32.tif','F_elephant33.tif','F_elephant34.tif','F_elephant35.tif'....
           'F_elephant36.tif','F_elephant37.tif','F_elephant38.tif','F_elephant39.tif','F_elephant40.tif','F_elephant41.tif','F_elephant42.tif'....
           'F_elephant43.tif','F_elephant44.tif','F_elephant45.tif','F_elephant46.tif','F_elephant47.tif','F_elephant48.tif','F_elephant49.tif',....
           'F_elephant50.tif','F_elephant51.tif','F_elephant52.tif','F_elephant53.tif','F_elephant54.tif','F_elephant55.tif','F_elephant56.tif'};   
       

Sample_female_transparent = {'F_transparent1.tif','F_transparent2.tif','F_transparent3.tif','F_transparent4.tif','F_transparent5.tif','F_transparent6.tif','F_transparent7.tif'....
           'F_transparent8.tif','F_transparent9.tif','F_transparent10.tif','F_transparent11.tif','F_transparent12.tif','F_transparent13.tif','F_transparent14.tif'....
           'F_transparent15.tif','F_transparent16.tif','F_transparent17.tif','F_transparent18.tif','F_transparent19.tif','F_transparent20.tif','F_transparent21.tif'....
           'F_transparent22.tif','F_transparent23.tif','F_transparent24.tif','F_transparent25.tif','F_transparent26.tif','F_transparent27.tif','F_transparent28.tif'....
           'F_transparent29.tif','F_transparent30.tif','F_transparent31.tif','F_transparent32.tif','F_transparent33.tif','F_transparent34.tif','F_transparent35.tif'....
           'F_transparent36.tif','F_transparent37.tif','F_transparent38.tif','F_transparent39.tif','F_transparent40.tif','F_transparent41.tif','F_transparent42.tif'....
           'F_transparent43.tif','F_transparent44.tif','F_transparent45.tif','F_transparent46.tif','F_transparent47.tif','F_transparent48.tif','F_transparent49.tif',....
           'F_transparent50.tif','F_transparent51.tif','F_transparent52.tif','F_transparent53.tif','F_transparent54.tif','F_transparent55.tif','F_transparent56.tif'};   

Sample_female_is = {'F_is1.tif','F_is2.tif','F_is3.tif','F_is4.tif','F_is5.tif','F_is6.tif','F_is7.tif'....
           'F_is8.tif','F_is9.tif','F_is10.tif','F_is11.tif','F_is12.tif','F_is13.tif','F_is14.tif'....
           'F_is15.tif','F_is16.tif','F_is17.tif','F_is18.tif','F_is19.tif','F_is20.tif','F_is21.tif'....
           'F_is22.tif','F_is23.tif','F_is24.tif','F_is25.tif','F_is26.tif','F_is27.tif','F_is28.tif'....
           'F_is29.tif','F_is30.tif','F_is31.tif','F_is32.tif','F_is33.tif','F_is34.tif','F_is35.tif'....
           'F_is36.tif','F_is37.tif','F_is38.tif','F_is39.tif','F_is40.tif','F_is41.tif','F_is42.tif'....
           'F_is43.tif','F_is44.tif','F_is45.tif','F_is46.tif','F_is47.tif','F_is48.tif','F_is49.tif',....
           'F_is50.tif','F_is51.tif','F_is52.tif','F_is53.tif','F_is54.tif','F_is55.tif','F_is56.tif'};   

Sample_female_green = {'F_green1.tif','F_green2.tif','F_green3.tif','F_green4.tif','F_green5.tif','F_green6.tif','F_green7.tif'....
           'F_green8.tif','F_green9.tif','F_green10.tif','F_green11.tif','F_green12.tif','F_green13.tif','F_green14.tif'....
           'F_green15.tif','F_green16.tif','F_green17.tif','F_green18.tif','F_green19.tif','F_green20.tif','F_green21.tif'....
           'F_green22.tif','F_green23.tif','F_green24.tif','F_green25.tif','F_green26.tif','F_green27.tif','F_green28.tif'....
           'F_green29.tif','F_green30.tif','F_green31.tif','F_green32.tif','F_green33.tif','F_green34.tif','F_green35.tif'....
           'F_green36.tif','F_green37.tif','F_green38.tif','F_green39.tif','F_green40.tif','F_green41.tif','F_green42.tif'....
           'F_green43.tif','F_green44.tif','F_green45.tif','F_green46.tif','F_green47.tif','F_green48.tif','F_green49.tif',....
           'F_green50.tif','F_green51.tif','F_green52.tif','F_green53.tif','F_green54.tif','F_green55.tif','F_green56.tif'};   

Sample_female_math = {'F_math1.tif','F_math2.tif','F_math3.tif','F_math4.tif','F_math5.tif','F_math6.tif','F_math7.tif'....
           'F_math8.tif','F_math9.tif','F_math10.tif','F_math11.tif','F_math12.tif','F_math13.tif','F_math14.tif'....
           'F_math15.tif','F_math16.tif','F_math17.tif','F_math18.tif','F_math19.tif','F_math20.tif','F_math21.tif'....
           'F_math22.tif','F_math23.tif','F_math24.tif','F_math25.tif','F_math26.tif','F_math27.tif','F_math28.tif'....
           'F_math29.tif','F_math30.tif','F_math31.tif','F_math32.tif','F_math33.tif','F_math34.tif','F_math35.tif'....
           'F_math36.tif','F_math37.tif','F_math38.tif','F_math39.tif','F_math40.tif','F_math41.tif','F_math42.tif'....
           'F_math43.tif','F_math44.tif','F_math45.tif','F_math46.tif','F_math47.tif','F_math48.tif','F_math49.tif',....
           'F_math50.tif','F_math51.tif','F_math52.tif','F_math53.tif','F_math54.tif','F_math55.tif','F_math56.tif'};   

Sample_female_stop = {'F_stop1.tif','F_stop2.tif','F_stop3.tif','F_stop4.tif','F_stop5.tif','F_stop6.tif','F_stop7.tif'....
           'F_stop8.tif','F_stop9.tif','F_stop10.tif','F_stop11.tif','F_stop12.tif','F_stop13.tif','F_stop14.tif'....
           'F_stop15.tif','F_stop16.tif','F_stop17.tif','F_stop18.tif','F_stop19.tif','F_stop20.tif','F_stop21.tif'....
           'F_stop22.tif','F_stop23.tif','F_stop24.tif','F_stop25.tif','F_stop26.tif','F_stop27.tif','F_stop28.tif'....
           'F_stop29.tif','F_stop30.tif','F_stop31.tif','F_stop32.tif','F_stop33.tif','F_stop34.tif','F_stop35.tif'....
           'F_stop36.tif','F_stop37.tif','F_stop38.tif','F_stop39.tif','F_stop40.tif','F_stop41.tif','F_stop42.tif'....
           'F_stop43.tif','F_stop44.tif','F_stop45.tif','F_stop46.tif','F_stop47.tif','F_stop48.tif','F_stop49.tif',....
           'F_stop50.tif','F_stop51.tif','F_stop52.tif','F_stop53.tif','F_stop54.tif','F_stop55.tif','F_stop56.tif'};   

Sample_female_money = {'F_money1.tif','F_money2.tif','F_money3.tif','F_money4.tif','F_money5.tif','F_money6.tif','F_money7.tif'....
           'F_money8.tif','F_money9.tif','F_money10.tif','F_money11.tif','F_money12.tif','F_money13.tif','F_money14.tif'....
           'F_money15.tif','F_money16.tif','F_money17.tif','F_money18.tif','F_money19.tif','F_money20.tif','F_money21.tif'....
           'F_money22.tif','F_money23.tif','F_money24.tif','F_money25.tif','F_money26.tif','F_money27.tif','F_money28.tif'....
           'F_money29.tif','F_money30.tif','F_money31.tif','F_money32.tif','F_money33.tif','F_money34.tif','F_money35.tif'....
           'F_money36.tif','F_money37.tif','F_money38.tif','F_money39.tif','F_money40.tif','F_money41.tif','F_money42.tif'....
           'F_money43.tif','F_money44.tif','F_money45.tif','F_money46.tif','F_money47.tif','F_money48.tif','F_money49.tif',....
           'F_money50.tif','F_money51.tif','F_money52.tif','F_money53.tif','F_money54.tif','F_money55.tif','F_money56.tif'};   

Sample_female_jfk = {'F_jfk1.tif','F_jfk2.tif','F_jfk3.tif','F_jfk4.tif','F_jfk5.tif','F_jfk6.tif','F_jfk7.tif'....
           'F_jfk8.tif','F_jfk9.tif','F_jfk10.tif','F_jfk11.tif','F_jfk12.tif','F_jfk13.tif','F_jfk14.tif'....
           'F_jfk15.tif','F_jfk16.tif','F_jfk17.tif','F_jfk18.tif','F_jfk19.tif','F_jfk20.tif','F_jfk21.tif'....
           'F_jfk22.tif','F_jfk23.tif','F_jfk24.tif','F_jfk25.tif','F_jfk26.tif','F_jfk27.tif','F_jfk28.tif'....
           'F_jfk29.tif','F_jfk30.tif','F_jfk31.tif','F_jfk32.tif','F_jfk33.tif','F_jfk34.tif','F_jfk35.tif'....
           'F_jfk36.tif','F_jfk37.tif','F_jfk38.tif','F_jfk39.tif','F_jfk40.tif','F_jfk41.tif','F_jfk42.tif'....
           'F_jfk43.tif','F_jfk44.tif','F_jfk45.tif','F_jfk46.tif','F_jfk47.tif','F_jfk48.tif','F_jfk49.tif',....
           'F_jfk50.tif','F_jfk51.tif','F_jfk52.tif','F_jfk53.tif','F_jfk54.tif','F_jfk55.tif','F_jfk56.tif'};  
       
Sample_female_mouse = {'F_mouse1.tif','F_mouse2.tif','F_mouse3.tif','F_mouse4.tif','F_mouse5.tif','F_mouse6.tif','F_mouse7.tif'....
           'F_mouse8.tif','F_mouse9.tif','F_mouse10.tif','F_mouse11.tif','F_mouse12.tif','F_mouse13.tif','F_mouse14.tif'....
           'F_mouse15.tif','F_mouse16.tif','F_mouse17.tif','F_mouse18.tif','F_mouse19.tif','F_mouse20.tif','F_mouse21.tif'....
           'F_mouse22.tif','F_mouse23.tif','F_mouse24.tif','F_mouse25.tif','F_mouse26.tif','F_mouse27.tif','F_mouse28.tif'....
           'F_mouse29.tif','F_mouse30.tif','F_mouse31.tif','F_mouse32.tif','F_mouse33.tif','F_mouse34.tif','F_mouse35.tif'....
           'F_mouse36.tif','F_mouse37.tif','F_mouse38.tif','F_mouse39.tif','F_mouse40.tif','F_mouse41.tif','F_mouse42.tif'....
           'F_mouse43.tif','F_mouse44.tif','F_mouse45.tif','F_mouse46.tif','F_mouse47.tif','F_mouse48.tif','F_mouse49.tif',....
           'F_mouse50.tif','F_mouse51.tif','F_mouse52.tif','F_mouse53.tif','F_mouse54.tif','F_mouse55.tif','F_mouse56.tif'};   

Sample_female_brazil = {'F_brazil1.tif','F_brazil2.tif','F_brazil3.tif','F_brazil4.tif','F_brazil5.tif','F_brazil6.tif','F_brazil7.tif'....
           'F_brazil8.tif','F_brazil9.tif','F_brazil10.tif','F_brazil11.tif','F_brazil12.tif','F_brazil13.tif','F_brazil14.tif'....
           'F_brazil15.tif','F_brazil16.tif','F_brazil17.tif','F_brazil18.tif','F_brazil19.tif','F_brazil20.tif','F_brazil21.tif'....
           'F_brazil22.tif','F_brazil23.tif','F_brazil24.tif','F_brazil25.tif','F_brazil26.tif','F_brazil27.tif','F_brazil28.tif'....
           'F_brazil29.tif','F_brazil30.tif','F_brazil31.tif','F_brazil32.tif','F_brazil33.tif','F_brazil34.tif','F_brazil35.tif'....
           'F_brazil36.tif','F_brazil37.tif','F_brazil38.tif','F_brazil39.tif','F_brazil40.tif','F_brazil41.tif','F_brazil42.tif'....
           'F_brazil43.tif','F_brazil44.tif','F_brazil45.tif','F_brazil46.tif','F_brazil47.tif','F_brazil48.tif','F_brazil49.tif',....
           'F_brazil50.tif','F_brazil51.tif','F_brazil52.tif','F_brazil53.tif','F_brazil54.tif','F_brazil55.tif','F_brazil56.tif'};   

Sample_female_apple = {'F_apple1.tif','F_apple2.tif','F_apple3.tif','F_apple4.tif','F_apple5.tif','F_apple6.tif','F_apple7.tif'....
           'F_apple8.tif','F_apple9.tif','F_apple10.tif','F_apple11.tif','F_apple12.tif','F_apple13.tif','F_apple14.tif'....
           'F_apple15.tif','F_apple16.tif','F_apple17.tif','F_apple18.tif','F_apple19.tif','F_apple20.tif','F_apple21.tif'....
           'F_apple22.tif','F_apple23.tif','F_apple24.tif','F_apple25.tif','F_apple26.tif','F_apple27.tif','F_apple28.tif'....
           'F_apple29.tif','F_apple30.tif','F_apple31.tif','F_apple32.tif','F_apple33.tif','F_apple34.tif','F_apple35.tif'....
           'F_apple36.tif','F_apple37.tif','F_apple38.tif','F_apple39.tif','F_apple40.tif','F_apple41.tif','F_apple42.tif'....
           'F_apple43.tif','F_apple44.tif','F_apple45.tif','F_apple46.tif','F_apple47.tif','F_apple48.tif','F_apple49.tif',....
           'F_apple50.tif','F_apple51.tif','F_apple52.tif','F_apple53.tif','F_apple54.tif','F_apple55.tif','F_apple56.tif'};   

Sample_female_moose = {'F_moose1.tif','F_moose2.tif','F_moose3.tif','F_moose4.tif','F_moose5.tif','F_moose6.tif','F_moose7.tif'....
           'F_moose8.tif','F_moose9.tif','F_moose10.tif','F_moose11.tif','F_moose12.tif','F_moose13.tif','F_moose14.tif'....
           'F_moose15.tif','F_moose16.tif','F_moose17.tif','F_moose18.tif','F_moose19.tif','F_moose20.tif','F_moose21.tif'....
           'F_moose22.tif','F_moose23.tif','F_moose24.tif','F_moose25.tif','F_moose26.tif','F_moose27.tif','F_moose28.tif'....
           'F_moose29.tif','F_moose30.tif','F_moose31.tif','F_moose32.tif','F_moose33.tif','F_moose34.tif','F_moose35.tif'....
           'F_moose36.tif','F_moose37.tif','F_moose38.tif','F_moose39.tif','F_moose40.tif','F_moose41.tif','F_moose42.tif'....
           'F_moose43.tif','F_moose44.tif','F_moose45.tif','F_moose46.tif','F_moose47.tif','F_moose48.tif','F_moose49.tif',....
           'F_moose50.tif','F_moose51.tif','F_moose52.tif','F_moose53.tif','F_moose54.tif','F_moose55.tif','F_moose56.tif'};   

Sample_female_deer = {'F_deer1.tif','F_deer2.tif','F_deer3.tif','F_deer4.tif','F_deer5.tif','F_deer6.tif','F_deer7.tif'....
           'F_deer8.tif','F_deer9.tif','F_deer10.tif','F_deer11.tif','F_deer12.tif','F_deer13.tif','F_deer14.tif'....
           'F_deer15.tif','F_deer16.tif','F_deer17.tif','F_deer18.tif','F_deer19.tif','F_deer20.tif','F_deer21.tif'....
           'F_deer22.tif','F_deer23.tif','F_deer24.tif','F_deer25.tif','F_deer26.tif','F_deer27.tif','F_deer28.tif'....
           'F_deer29.tif','F_deer30.tif','F_deer31.tif','F_deer32.tif','F_deer33.tif','F_deer34.tif','F_deer35.tif'....
           'F_deer36.tif','F_deer37.tif','F_deer38.tif','F_deer39.tif','F_deer40.tif','F_deer41.tif','F_deer42.tif'....
           'F_deer43.tif','F_deer44.tif','F_deer45.tif','F_deer46.tif','F_deer47.tif','F_deer48.tif','F_deer49.tif',....
           'F_deer50.tif','F_deer51.tif','F_deer52.tif','F_deer53.tif','F_deer54.tif','F_deer55.tif','F_deer56.tif'};   

Sample_female_cool = {'F_cool1.tif','F_cool2.tif','F_cool3.tif','F_cool4.tif','F_cool5.tif','F_cool6.tif','F_cool7.tif'....
           'F_cool8.tif','F_cool9.tif','F_cool10.tif','F_cool11.tif','F_cool12.tif','F_cool13.tif','F_cool14.tif'....
           'F_cool15.tif','F_cool16.tif','F_cool17.tif','F_cool18.tif','F_cool19.tif','F_cool20.tif','F_cool21.tif'....
           'F_cool22.tif','F_cool23.tif','F_cool24.tif','F_cool25.tif','F_cool26.tif','F_cool27.tif','F_cool28.tif'....
           'F_cool29.tif','F_cool30.tif','F_cool31.tif','F_cool32.tif','F_cool33.tif','F_cool34.tif','F_cool35.tif'....
           'F_cool36.tif','F_cool37.tif','F_cool38.tif','F_cool39.tif','F_cool40.tif','F_cool41.tif','F_cool42.tif'....
           'F_cool43.tif','F_cool44.tif','F_cool45.tif','F_cool46.tif','F_cool47.tif','F_cool48.tif','F_cool49.tif',....
           'F_cool50.tif','F_cool51.tif','F_cool52.tif','F_cool53.tif','F_cool54.tif','F_cool55.tif','F_cool56.tif'};   

Sample_female_jacket = {'F_jacket1.tif','F_jacket2.tif','F_jacket3.tif','F_jacket4.tif','F_jacket5.tif','F_jacket6.tif','F_jacket7.tif'....
           'F_jacket8.tif','F_jacket9.tif','F_jacket10.tif','F_jacket11.tif','F_jacket12.tif','F_jacket13.tif','F_jacket14.tif'....
           'F_jacket15.tif','F_jacket16.tif','F_jacket17.tif','F_jacket18.tif','F_jacket19.tif','F_jacket20.tif','F_jacket21.tif'....
           'F_jacket22.tif','F_jacket23.tif','F_jacket24.tif','F_jacket25.tif','F_jacket26.tif','F_jacket27.tif','F_jacket28.tif'....
           'F_jacket29.tif','F_jacket30.tif','F_jacket31.tif','F_jacket32.tif','F_jacket33.tif','F_jacket34.tif','F_jacket35.tif'....
           'F_jacket36.tif','F_jacket37.tif','F_jacket38.tif','F_jacket39.tif','F_jacket40.tif','F_jacket41.tif','F_jacket42.tif'....
           'F_jacket43.tif','F_jacket44.tif','F_jacket45.tif','F_jacket46.tif','F_jacket47.tif','F_jacket48.tif','F_jacket49.tif',....
           'F_jacket50.tif','F_jacket51.tif','F_jacket52.tif','F_jacket53.tif','F_jacket54.tif','F_jacket55.tif','F_jacket56.tif'};   
       
       
% Male Sample Headers:

Sample_male_A1tif = {'M_A1.tif','M_A2.tif','M_A5.tif','M_A7.tif','M_A9.tif','M_A10.tif','M_A11.tif'....
           'M_A12.tif','M_A13.tif','M_A15.tif','M_A16.tif','M_A17.tif','M_A18.tif','M_A19.tif'....
           'M_A20.tif','M_A21.tif','M_A22.tif','M_A23.tif','M_A24.tif','M_A25.tif','M_A27.tif'....
           'M_A28.tif','M_A29.tif','M_A30.tif','M_A31.tif','M_A32.tif','M_A33.tif','M_A34.tif'....
           'M_A35.tif','M_A36.tif','M_A37.tif','M_A38.tif','M_A39.tif','M_A40.tif','M_A41.tif'....
           'M_A42.tif','M_A43.tif','M_A44.tif','M_45.tif','M_A46.tif','M_A47.tif'};   
       
Sample_male_Btif = {'M_B1.tif','M_B2.tif','M_B5.tif','M_B7.tif','M_B9.tif','M_B10.tif','M_B11.tif'....
           'M_B12.tif','M_B13.tif','M_B15.tif','M_B16.tif','M_B17.tif','M_B18.tif','M_B19.tif'....
           'M_B20.tif','M_B21.tif','M_B22.tif','M_B23.tif','M_B24.tif','M_B25.tif','M_B27.tif'....
           'M_B28.tif','M_B29.tif','M_B30.tif','M_B31.tif','M_B32.tif','M_B33.tif','M_B34.tif'....
           'M_B35.tif','M_B36.tif','M_B37.tif','M_B38.tif','M_B39.tif','M_B40.tif','M_B41.tif'....
           'M_B42.tif','M_B43.tif','M_B44.tif','M_45.tif','M_B46.tif','M_B47.tif'};     

Sample_male_Etif = {'M_E1.tif','M_E2.tif','M_E5.tif','M_E7.tif','M_E9.tif','M_E10.tif','M_E11.tif'....
           'M_E12.tif','M_E13.tif','M_E15.tif','M_E16.tif','M_E17.tif','M_E18.tif','M_E19.tif'....
           'M_E20.tif','M_E21.tif','M_E22.tif','M_E23.tif','M_E24.tif','M_E25.tif','M_E27.tif'....
           'M_E28.tif','M_E29.tif','M_E30.tif','M_E31.tif','M_E32.tif','M_E33.tif','M_E34.tif'....
           'M_E35.tif','M_E36.tif','M_E37.tif','M_E38.tif','M_E39.tif','M_E40.tif','M_E41.tif'....
           'M_E42.tif','M_E43.tif','M_E44.tif','M_45.tif','M_E46.tif','M_E47.tif'};     
       
Sample_male_Gtif = {'M_G1.tif','M_G2.tif','M_G5.tif','M_G7.tif','M_G9.tif','M_G10.tif','M_G11.tif'....
           'M_G12.tif','M_G13.tif','M_G15.tif','M_G16.tif','M_G17.tif','M_G18.tif','M_G19.tif'....
           'M_G20.tif','M_G21.tif','M_G22.tif','M_G23.tif','M_G24.tif','M_G25.tif','M_G27.tif'....
           'M_G28.tif','M_G29.tif','M_G30.tif','M_G31.tif','M_G32.tif','M_G33.tif','M_G34.tif'....
           'M_G35.tif','M_G36.tif','M_G37.tif','M_G38.tif','M_G39.tif','M_G40.tif','M_G41.tif'....
           'M_G42.tif','M_G43.tif','M_G44.tif','M_45.tif','M_G46.tif','M_G47.tif'};    
   

Sample_male_Htif = {'M_H1.tif','M_H2.tif','M_H5.tif','M_H7.tif','M_H9.tif','M_H10.tif','M_H11.tif'....
           'M_H12.tif','M_H13.tif','M_H15.tif','M_H16.tif','M_H17.tif','M_H18.tif','M_H19.tif'....
           'M_H20.tif','M_H21.tif','M_H22.tif','M_H23.tif','M_H24.tif','M_H25.tif','M_H27.tif'....
           'M_H28.tif','M_H29.tif','M_H30.tif','M_H31.tif','M_H32.tif','M_H33.tif','M_H34.tif'....
           'M_H35.tif','M_H36.tif','M_H37.tif','M_H38.tif','M_H39.tif','M_H40.tif','M_H41.tif'....
           'M_H42.tif','M_H43.tif','M_H44.tif','M_45.tif','M_H46.tif','M_H47.tif'};    

Sample_male_Ktif = {'M_K1.tif','M_K2.tif','M_K5.tif','M_K7.tif','M_K9.tif','M_K10.tif','M_K11.tif'....
           'M_K12.tif','M_K13.tif','M_K15.tif','M_K16.tif','M_K17.tif','M_K18.tif','M_K19.tif'....
           'M_K20.tif','M_K21.tif','M_K22.tif','M_K23.tif','M_K24.tif','M_K25.tif','M_K27.tif'....
           'M_K28.tif','M_K29.tif','M_K30.tif','M_K31.tif','M_K32.tif','M_K33.tif','M_K34.tif'....
           'M_K35.tif','M_K36.tif','M_K37.tif','M_K38.tif','M_K39.tif','M_K40.tif','M_K41.tif'....
           'M_K42.tif','M_K43.tif','M_K44.tif','M_45.tif','M_K46.tif','M_K47.tif'};  

Sample_male_Mtif = {'M_M1.tif','M_M2.tif','M_M5.tif','M_M7.tif','M_M9.tif','M_M10.tif','M_M11.tif'....
           'M_M12.tif','M_M13.tif','M_M15.tif','M_M16.tif','M_M17.tif','M_M18.tif','M_M19.tif'....
           'M_M20.tif','M_M21.tif','M_M22.tif','M_M23.tif','M_M24.tif','M_M25.tif','M_M27.tif'....
           'M_M28.tif','M_M29.tif','M_M30.tif','M_M31.tif','M_M32.tif','M_M33.tif','M_M34.tif'....
           'M_M35.tif','M_M36.tif','M_M37.tif','M_M38.tif','M_M39.tif','M_M40.tif','M_M41.tif'....
           'M_M42.tif','M_M43.tif','M_M44.tif','M_45.tif','M_M46.tif','M_M47.tif'};  
       
Sample_male_Ptif = {'P_M1.tif','P_M2.tif','P_M5.tif','P_M7.tif','P_M9.tif','P_M10.tif','P_M11.tif'....
           'P_M12.tif','P_M13.tif','P_M15.tif','P_M16.tif','P_M17.tif','P_M18.tif','P_M19.tif'....
           'P_M20.tif','P_M21.tif','P_M22.tif','P_M23.tif','P_M24.tif','P_M25.tif','P_M27.tif'....
           'P_M28.tif','P_M29.tif','P_M30.tif','P_M31.tif','P_M32.tif','P_M33.tif','P_M34.tif'....
           'P_M35.tif','P_M36.tif','P_M37.tif','P_M38.tif','P_M39.tif','P_M40.tif','P_M41.tif'....
           'P_M42.tif','P_M43.tif','P_M44.tif','P_M45.tif','P_M46.tif','P_M47.tif'};    

Sample_male_jesus = {'jesus_M1.tif','jesus_M2.tif','jesus_M5.tif','jesus_M7.tif','jesus_M9.tif','jesus_M10.tif','jesus_M11.tif'....
           'jesus_M12.tif','jesus_M13.tif','jesus_M15.tif','jesus_M16.tif','jesus_M17.tif','jesus_M18.tif','jesus_M19.tif'....
           'jesus_M20.tif','jesus_M21.tif','jesus_M22.tif','jesus_M23.tif','jesus_M24.tif','jesus_M25.tif','jesus_M27.tif'....
           'jesus_M28.tif','jesus_M29.tif','jesus_M30.tif','jesus_M31.tif','jesus_M32.tif','jesus_M33.tif','jesus_M34.tif'....
           'jesus_M35.tif','jesus_M36.tif','jesus_M37.tif','jesus_M38.tif','jesus_M39.tif','jesus_M40.tif','jesus_M41.tif'....
           'jesus_M42.tif','jesus_M43.tif','jesus_M44.tif','jesus_M45.tif','jesus_M46.tif','jesus_M47.tif'};  
       
Sample_male_loves = {'loves_M1.tif','loves_M2.tif','loves_M5.tif','loves_M7.tif','loves_M9.tif','loves_M10.tif','loves_M11.tif'....
           'loves_M12.tif','loves_M13.tif','loves_M15.tif','loves_M16.tif','loves_M17.tif','loves_M18.tif','loves_M19.tif'....
           'loves_M20.tif','loves_M21.tif','loves_M22.tif','loves_M23.tif','loves_M24.tif','loves_M25.tif','loves_M27.tif'....
           'loves_M28.tif','loves_M29.tif','loves_M30.tif','loves_M31.tif','loves_M32.tif','loves_M33.tif','loves_M34.tif'....
           'loves_M35.tif','loves_M36.tif','loves_M37.tif','loves_M38.tif','loves_M39.tif','loves_M40.tif','loves_M41.tif'....
           'loves_M42.tif','loves_M43.tif','loves_M44.tif','loves_M45.tif','loves_M46.tif','loves_M47.tif'};  

Sample_male_you = {'you_M1.tif','you_M2.tif','you_M5.tif','you_M7.tif','you_M9.tif','you_M10.tif','you_M11.tif'....
           'you_M12.tif','you_M13.tif','you_M15.tif','you_M16.tif','you_M17.tif','you_M18.tif','you_M19.tif'....
           'you_M20.tif','you_M21.tif','you_M22.tif','you_M23.tif','you_M24.tif','you_M25.tif','you_M27.tif'....
           'you_M28.tif','you_M29.tif','you_M30.tif','you_M31.tif','you_M32.tif','you_M33.tif','you_M34.tif'....
           'you_M35.tif','you_M36.tif','you_M37.tif','you_M38.tif','you_M39.tif','you_M40.tif','you_M41.tif'....
           'you_M42.tif','you_M43.tif','you_M44.tif','you_M45.tif','you_M46.tif','you_M47.tif'};  

Sample_male_time = {'time_M1.tif','time_M2.tif','time_M5.tif','time_M7.tif','time_M9.tif','time_M10.tif','time_M11.tif'....
           'time_M12.tif','time_M13.tif','time_M15.tif','time_M16.tif','time_M17.tif','time_M18.tif','time_M19.tif'....
           'time_M20.tif','time_M21.tif','time_M22.tif','time_M23.tif','time_M24.tif','time_M25.tif','time_M27.tif'....
           'time_M28.tif','time_M29.tif','time_M30.tif','time_M31.tif','time_M32.tif','time_M33.tif','time_M34.tif'....
           'time_M35.tif','time_M36.tif','time_M37.tif','time_M38.tif','time_M39.tif','time_M40.tif','time_M41.tif'....
           'time_M42.tif','time_M43.tif','time_M44.tif','time_M45.tif','time_M46.tif','time_M47.tif'};  

Sample_male_unforgiven = {'unforgiven_M1.tif','unforgiven_M2.tif','unforgiven_M5.tif','unforgiven_M7.tif','unforgiven_M9.tif','unforgiven_M10.tif','unforgiven_M11.tif'....
           'unforgiven_M12.tif','unforgiven_M13.tif','unforgiven_M15.tif','unforgiven_M16.tif','unforgiven_M17.tif','unforgiven_M18.tif','unforgiven_M19.tif'....
           'unforgiven_M20.tif','unforgiven_M21.tif','unforgiven_M22.tif','unforgiven_M23.tif','unforgiven_M24.tif','unforgiven_M25.tif','unforgiven_M27.tif'....
           'unforgiven_M28.tif','unforgiven_M29.tif','unforgiven_M30.tif','unforgiven_M31.tif','unforgiven_M32.tif','unforgiven_M33.tif','unforgiven_M34.tif'....
           'unforgiven_M35.tif','unforgiven_M36.tif','unforgiven_M37.tif','unforgiven_M38.tif','unforgiven_M39.tif','unforgiven_M40.tif','unforgiven_M41.tif'....
           'unforgiven_M42.tif','unforgiven_M43.tif','unforgiven_M44.tif','unforgiven_M45.tif','unforgiven_M46.tif','unforgiven_M47.tif'};  
       

Sample_male_transparent = {'transparent_M1.tif','transparent_M2.tif','transparent_M5.tif','transparent_M7.tif','transparent_M9.tif','transparent_M10.tif','transparent_M11.tif'....
           'transparent_M12.tif','transparent_M13.tif','transparent_M15.tif','transparent_M16.tif','transparent_M17.tif','transparent_M18.tif','transparent_M19.tif'....
           'transparent_M20.tif','transparent_M21.tif','transparent_M22.tif','transparent_M23.tif','transparent_M24.tif','transparent_M25.tif','transparent_M27.tif'....
           'transparent_M28.tif','transparent_M29.tif','transparent_M30.tif','transparent_M31.tif','transparent_M32.tif','transparent_M33.tif','transparent_M34.tif'....
           'transparent_M35.tif','transparent_M36.tif','transparent_M37.tif','transparent_M38.tif','transparent_M39.tif','transparent_M40.tif','transparent_M41.tif'....
           'transparent_M42.tif','transparent_M43.tif','transparent_M44.tif','transparent_M45.tif','transparent_M46.tif','transparent_M47.tif'};  

Sample_male_is = {'is_M1.tif','is_M2.tif','is_M5.tif','is_M7.tif','is_M9.tif','is_M10.tif','is_M11.tif'....
           'is_M12.tif','is_M13.tif','is_M15.tif','is_M16.tif','is_M17.tif','is_M18.tif','is_M19.tif'....
           'is_M20.tif','is_M21.tif','is_M22.tif','is_M23.tif','is_M24.tif','is_M25.tif','is_M27.tif'....
           'is_M28.tif','is_M29.tif','is_M30.tif','is_M31.tif','is_M32.tif','is_M33.tif','is_M34.tif'....
           'is_M35.tif','is_M36.tif','is_M37.tif','is_M38.tif','is_M39.tif','is_M40.tif','is_M41.tif'....
           'is_M42.tif','is_M43.tif','is_M44.tif','is_M45.tif','is_M46.tif','is_M47.tif'};   

Sample_male_green = {'green_M1.tif','green_M2.tif','green_M5.tif','green_M7.tif','green_M9.tif','green_M10.tif','green_M11.tif'....
           'green_M12.tif','green_M13.tif','green_M15.tif','green_M16.tif','green_M17.tif','green_M18.tif','green_M19.tif'....
           'green_M20.tif','green_M21.tif','green_M22.tif','green_M23.tif','green_M24.tif','green_M25.tif','green_M27.tif'....
           'green_M28.tif','green_M29.tif','green_M30.tif','green_M31.tif','green_M32.tif','green_M33.tif','green_M34.tif'....
           'green_M35.tif','green_M36.tif','green_M37.tif','green_M38.tif','green_M39.tif','green_M40.tif','green_M41.tif'....
           'green_M42.tif','green_M43.tif','green_M44.tif','green_M45.tif','green_M46.tif','green_M47.tif'};  
       
Sample_male_math = {'math_M1.tif','math_M2.tif','math_M5.tif','math_M7.tif','math_M9.tif','math_M10.tif','math_M11.tif'....
           'math_M12.tif','math_M13.tif','math_M15.tif','math_M16.tif','math_M17.tif','math_M18.tif','math_M19.tif'....
           'math_M20.tif','math_M21.tif','math_M22.tif','math_M23.tif','math_M24.tif','math_M25.tif','math_M27.tif'....
           'math_M28.tif','math_M29.tif','math_M30.tif','math_M31.tif','math_M32.tif','math_M33.tif','math_M34.tif'....
           'math_M35.tif','math_M36.tif','math_M37.tif','math_M38.tif','math_M39.tif','math_M40.tif','math_M41.tif'....
           'math_M42.tif','math_M43.tif','math_M44.tif','math_M45.tif','math_M46.tif','math_M47.tif'};  

Sample_male_stop = {'stop_M1.tif','stop_M2.tif','stop_M5.tif','stop_M7.tif','stop_M9.tif','stop_M10.tif','stop_M11.tif'....
           'stop_M12.tif','stop_M13.tif','stop_M15.tif','stop_M16.tif','stop_M17.tif','stop_M18.tif','stop_M19.tif'....
           'stop_M20.tif','stop_M21.tif','stop_M22.tif','stop_M23.tif','stop_M24.tif','stop_M25.tif','stop_M27.tif'....
           'stop_M28.tif','stop_M29.tif','stop_M30.tif','stop_M31.tif','stop_M32.tif','stop_M33.tif','stop_M34.tif'....
           'stop_M35.tif','stop_M36.tif','stop_M37.tif','stop_M38.tif','stop_M39.tif','stop_M40.tif','stop_M41.tif'....
           'stop_M42.tif','stop_M43.tif','stop_M44.tif','stop_M45.tif','stop_M46.tif','stop_M47.tif'};  

Sample_male_money = {'money_M1.tif','money_M2.tif','money_M5.tif','money_M7.tif','money_M9.tif','money_M10.tif','money_M11.tif'....
           'money_M12.tif','money_M13.tif','money_M15.tif','money_M16.tif','money_M17.tif','money_M18.tif','money_M19.tif'....
           'money_M20.tif','money_M21.tif','money_M22.tif','money_M23.tif','money_M24.tif','money_M25.tif','money_M27.tif'....
           'money_M28.tif','money_M29.tif','money_M30.tif','money_M31.tif','money_M32.tif','money_M33.tif','money_M34.tif'....
           'money_M35.tif','money_M36.tif','money_M37.tif','money_M38.tif','money_M39.tif','money_M40.tif','money_M41.tif'....
           'money_M42.tif','money_M43.tif','money_M44.tif','money_M45.tif','money_M46.tif','money_M47.tif'};  
%
Sample_male_elephant = {'F_elephant1.tif','F_elephant2.tif','F_elephant3.tif','F_elephant4.tif','F_elephant5.tif','F_elephant6.tif','F_elephant7.tif'....
           'F_elephant8.tif','F_elephant9.tif','F_elephant10.tif','F_elephant11.tif','F_elephant12.tif','F_elephant13.tif','F_elephant14.tif'....
           'F_elephant15.tif','F_elephant16.tif','F_elephant17.tif','F_elephant18.tif','F_elephant19.tif','F_elephant20.tif','F_elephant21.tif'....
           'F_elephant22.tif','F_elephant23.tif','F_elephant24.tif','F_elephant25.tif','F_elephant26.tif','F_elephant27.tif','F_elephant28.tif'....
           'F_elephant29.tif','F_elephant30.tif','F_elephant31.tif','F_elephant32.tif','F_elephant33.tif','F_elephant34.tif','F_elephant35.tif'....
           'F_elephant36.tif','F_elephant37.tif','F_elephant38.tif','F_elephant39.tif','F_elephant40.tif','F_elephant41.tif','F_elephant42.tif'....
           'F_elephant43.tif','F_elephant44.tif','F_elephant45.tif','F_elephant46.tif','F_elephant47.tif','F_elephant48.tif','F_elephant49.tif',....
           'F_elephant50.tif','F_elephant51.tif','F_elephant52.tif','F_elephant53.tif','F_elephant54.tif','F_elephant55.tif','F_elephant56.tif'};   
       %
Sample_male_jfk = {'jfk_M1.tif','jfk_M2.tif','jfk_M5.tif','jfk_M7.tif','jfk_M9.tif','jfk_M10.tif','jfk_M11.tif'....
           'jfk_M12.tif','jfk_M13.tif','jfk_M15.tif','jfk_M16.tif','jfk_M17.tif','jfk_M18.tif','jfk_M19.tif'....
           'jfk_M20.tif','jfk_M21.tif','jfk_M22.tif','jfk_M23.tif','jfk_M24.tif','jfk_M25.tif','jfk_M27.tif'....
           'jfk_M28.tif','jfk_M29.tif','jfk_M30.tif','jfk_M31.tif','jfk_M32.tif','jfk_M33.tif','jfk_M34.tif'....
           'jfk_M35.tif','jfk_M36.tif','jfk_M37.tif','jfk_M38.tif','jfk_M39.tif','jfk_M40.tif','jfk_M41.tif'....
           'jfk_M42.tif','jfk_M43.tif','jfk_M44.tif','jfk_M45.tif','jfk_M46.tif','jfk_M47.tif'};  
       
Sample_male_mouse = {'mouse_M1.tif','mouse_M2.tif','mouse_M5.tif','mouse_M7.tif','mouse_M9.tif','mouse_M10.tif','mouse_M11.tif'....
           'mouse_M12.tif','mouse_M13.tif','mouse_M15.tif','mouse_M16.tif','mouse_M17.tif','mouse_M18.tif','mouse_M19.tif'....
           'mouse_M20.tif','mouse_M21.tif','mouse_M22.tif','mouse_M23.tif','mouse_M24.tif','mouse_M25.tif','mouse_M27.tif'....
           'mouse_M28.tif','mouse_M29.tif','mouse_M30.tif','mouse_M31.tif','mouse_M32.tif','mouse_M33.tif','mouse_M34.tif'....
           'mouse_M35.tif','mouse_M36.tif','mouse_M37.tif','mouse_M38.tif','mouse_M39.tif','mouse_M40.tif','mouse_M41.tif'....
           'mouse_M42.tif','mouse_M43.tif','mouse_M44.tif','mouse_M45.tif','mouse_M46.tif','mouse_M47.tif'};  

Sample_male_brazil = {'brazil_M1.tif','brazil_M2.tif','brazil_M5.tif','brazil_M7.tif','brazil_M9.tif','brazil_M10.tif','brazil_M11.tif'....
           'brazil_M12.tif','brazil_M13.tif','brazil_M15.tif','brazil_M16.tif','brazil_M17.tif','brazil_M18.tif','brazil_M19.tif'....
           'brazil_M20.tif','brazil_M21.tif','brazil_M22.tif','brazil_M23.tif','brazil_M24.tif','brazil_M25.tif','brazil_M27.tif'....
           'brazil_M28.tif','brazil_M29.tif','brazil_M30.tif','brazil_M31.tif','brazil_M32.tif','brazil_M33.tif','brazil_M34.tif'....
           'brazil_M35.tif','brazil_M36.tif','brazil_M37.tif','brazil_M38.tif','brazil_M39.tif','brazil_M40.tif','brazil_M41.tif'....
           'brazil_M42.tif','brazil_M43.tif','brazil_M44.tif','brazil_M45.tif','brazil_M46.tif','brazil_M47.tif'};  


Sample_male_apple = {'apple_M1.tif','apple_M2.tif','apple_M5.tif','apple_M7.tif','apple_M9.tif','apple_M10.tif','apple_M11.tif'....
           'apple_M12.tif','apple_M13.tif','apple_M15.tif','apple_M16.tif','apple_M17.tif','apple_M18.tif','apple_M19.tif'....
           'apple_M20.tif','apple_M21.tif','apple_M22.tif','apple_M23.tif','apple_M24.tif','apple_M25.tif','apple_M27.tif'....
           'apple_M28.tif','apple_M29.tif','apple_M30.tif','apple_M31.tif','apple_M32.tif','apple_M33.tif','apple_M34.tif'....
           'apple_M35.tif','apple_M36.tif','apple_M37.tif','apple_M38.tif','apple_M39.tif','apple_M40.tif','apple_M41.tif'....
           'apple_M42.tif','apple_M43.tif','apple_M44.tif','apple_M45.tif','apple_M46.tif','apple_M47.tif'};  

Sample_male_moose = {'moose_M1.tif','moose_M2.tif','moose_M5.tif','moose_M7.tif','moose_M9.tif','moose_M10.tif','moose_M11.tif'....
           'moose_M12.tif','moose_M13.tif','moose_M15.tif','moose_M16.tif','moose_M17.tif','moose_M18.tif','moose_M19.tif'....
           'moose_M20.tif','moose_M21.tif','moose_M22.tif','moose_M23.tif','moose_M24.tif','moose_M25.tif','moose_M27.tif'....
           'moose_M28.tif','moose_M29.tif','moose_M30.tif','moose_M31.tif','moose_M32.tif','moose_M33.tif','moose_M34.tif'....
           'moose_M35.tif','moose_M36.tif','moose_M37.tif','moose_M38.tif','moose_M39.tif','moose_M40.tif','moose_M41.tif'....
           'moose_M42.tif','moose_M43.tif','moose_M44.tif','moose_M45.tif','moose_M46.tif','moose_M47.tif'};  
       
Sample_male_deer = {'deer_M1.tif','deer_M2.tif','deer_M5.tif','deer_M7.tif','deer_M9.tif','deer_M10.tif','deer_M11.tif'....
           'deer_M12.tif','deer_M13.tif','deer_M15.tif','deer_M16.tif','deer_M17.tif','deer_M18.tif','deer_M19.tif'....
           'deer_M20.tif','deer_M21.tif','deer_M22.tif','deer_M23.tif','deer_M24.tif','deer_M25.tif','deer_M27.tif'....
           'deer_M28.tif','deer_M29.tif','deer_M30.tif','deer_M31.tif','deer_M32.tif','deer_M33.tif','deer_M34.tif'....
           'deer_M35.tif','deer_M36.tif','deer_M37.tif','deer_M38.tif','deer_M39.tif','deer_M40.tif','deer_M41.tif'....
           'deer_M42.tif','deer_M43.tif','deer_M44.tif','deer_M45.tif','deer_M46.tif','deer_M47.tif'};  

Sample_male_cool = {'cool_M1.tif','cool_M2.tif','cool_M5.tif','cool_M7.tif','cool_M9.tif','cool_M10.tif','cool_M11.tif'....
           'cool_M12.tif','cool_M13.tif','cool_M15.tif','cool_M16.tif','cool_M17.tif','cool_M18.tif','cool_M19.tif'....
           'cool_M20.tif','cool_M21.tif','cool_M22.tif','cool_M23.tif','cool_M24.tif','cool_M25.tif','cool_M27.tif'....
           'cool_M28.tif','cool_M29.tif','cool_M30.tif','cool_M31.tif','cool_M32.tif','cool_M33.tif','cool_M34.tif'....
           'cool_M35.tif','cool_M36.tif','cool_M37.tif','cool_M38.tif','cool_M39.tif','cool_M40.tif','cool_M41.tif'....
           'cool_M42.tif','cool_M43.tif','cool_M44.tif','cool_M45.tif','cool_M46.tif','cool_M47.tif'};  
       
Sample_male_jacket = {'jacket_M1.tif','jacket_M2.tif','jacket_M5.tif','jacket_M7.tif','jacket_M9.tif','jacket_M10.tif','jacket_M11.tif'....
           'jacket_M12.tif','jacket_M13.tif','jacket_M15.tif','jacket_M16.tif','jacket_M17.tif','jacket_M18.tif','jacket_M19.tif'....
           'jacket_M20.tif','jacket_M21.tif','jacket_M22.tif','jacket_M23.tif','jacket_M24.tif','jacket_M25.tif','jacket_M27.tif'....
           'jacket_M28.tif','jacket_M29.tif','jacket_M30.tif','jacket_M31.tif','jacket_M32.tif','jacket_M33.tif','jacket_M34.tif'....
           'jacket_M35.tif','jacket_M36.tif','jacket_M37.tif','jacket_M38.tif','jacket_M39.tif','jacket_M40.tif','jacket_M41.tif'....
           'jacket_M42.tif','jacket_M43.tif','jacket_M44.tif','jacket_M45.tif','jacket_M46.tif','jacket_M47.tif'};  
       
%% Array List:
entropy_array_F_A = 1:56;
entropy_array_F_B = 1:56;
entropy_array_F_E = 1:56;
entropy_array_F_G = 1:56;
entropy_array_F_H = 1:56;
entropy_array_F_K = 1:56;
entropy_array_F_M = 1:56;
entropy_array_F_P = 1:56;
entropy_array_F_jesus = 1:56;
entropy_array_F_loves = 1:56;
entropy_array_F_you = 1:56;
entropy_array_F_time = 1:56;
entropy_array_F_unforgiven = 1:56;
entropy_array_F_elephant = 1:56;
entropy_array_F_transparent = 1:56;
entropy_array_F_is = 1:56;
entropy_array_F_green = 1:56;
entropy_array_F_math = 1:56;
entropy_array_F_stop = 1:56;
entropy_array_F_money = 1:56;
entropy_array_F_jfk = 1:56;
entropy_array_F_mouse = 1:56;
entropy_array_F_brazil = 1:56;
entropy_array_F_apple = 1:56;
entropy_array_F_moose = 1:56;
entropy_array_F_deer = 1:56;
entropy_array_F_cool = 1:56;
entropy_array_F_jacket = 1:56;

entropy_array_M_A = 1:41;
entropy_array_M_B = 1:41;
entropy_array_M_E = 1:41;
entropy_array_M_G = 1:41;
entropy_array_M_H = 1:41;
entropy_array_M_K = 1:41;
entropy_array_M_M = 1:41;
entropy_array_M_P = 1:41;
entropy_array_M_jesus = 1:41;
entropy_array_M_loves = 1:41;
entropy_array_M_you = 1:41;
entropy_array_M_time = 1:41;
entropy_array_M_unforgiven = 1:41;
entropy_array_M_elephant = 1:41;
entropy_array_M_transparent = 1:41;
entropy_array_M_is = 1:41;
entropy_array_M_green = 1:41;
entropy_array_M_math = 1:41;
entropy_array_M_stop = 1:41;
entropy_array_M_money = 1:41;
entropy_array_M_jfk = 1:41;
entropy_array_M_mouse = 1:41;
entropy_array_M_brazil = 1:41;
entropy_array_M_apple = 1:41;
entropy_array_M_moose = 1:41;
entropy_array_M_deer = 1:41;
entropy_array_M_cool = 1:41;
entropy_array_M_jacket = 1:41;

binary_array_F_A = 1:56;
binary_array_F_B = 1:56;
binary_array_F_E = 1:56;
binary_array_F_G = 1:56;
binary_array_F_H = 1:56;
binary_array_F_K = 1:56;
binary_array_F_M = 1:56;
binary_array_F_P = 1:56;
binary_array_F_jesus = 1:56;
binary_array_F_loves = 1:56;
binary_array_F_you = 1:56;
binary_array_F_time = 1:56;
binary_array_F_unforgiven = 1:56;
binary_array_F_elephant = 1:56;
binary_array_F_transparent = 1:56;
binary_array_F_is = 1:56;
binary_array_F_green = 1:56;
binary_array_F_math = 1:56;
binary_array_F_stop = 1:56;
binary_array_F_money = 1:56;
binary_array_F_jfk = 1:56;
binary_array_F_mouse = 1:56;
binary_array_F_brazil = 1:56;
binary_array_F_apple = 1:56;
binary_array_F_moose = 1:56;
binary_array_F_deer = 1:56;
binary_array_F_cool = 1:56;
binary_array_F_jacket = 1:56;

binary_array_M_A = 1:41;
binary_array_M_B = 1:41;
binary_array_M_E = 1:41;
binary_array_M_G = 1:41;
binary_array_M_H = 1:41;
binary_array_M_K = 1:41;
binary_array_M_M = 1:41;
binary_array_M_P = 1:41;
binary_array_M_jesus = 1:41;
binary_array_M_loves = 1:41;
binary_array_M_you = 1:41;
binary_array_M_time = 1:41;
binary_array_M_unforgiven = 1:41;
binary_array_M_elephant = 1:41;
binary_array_M_transparent = 1:41;
binary_array_M_is = 1:41;
binary_array_M_green = 1:41;
binary_array_M_math = 1:41;
binary_array_M_stop = 1:41;
binary_array_M_money = 1:41;
binary_array_M_jfk = 1:41;
binary_array_M_mouse = 1:41;
binary_array_M_brazil = 1:41;
binary_array_M_apple = 1:41;
binary_array_M_moose = 1:41;
binary_array_M_deer = 1:41;
binary_array_M_cool = 1:41;
binary_array_M_jacket = 1:41;

perVertLeft_array_M_A = 1:41;
perVertLeft_array_M_B = 1:41;
perVertLeft_array_M_E = 1:41;
perVertLeft_array_M_G = 1:41;
perVertLeft_array_M_H = 1:41;
perVertLeft_array_M_K = 1:41;
perVertLeft_array_M_M = 1:41;
perVertLeft_array_M_P = 1:41;
perVertLeft_array_M_jesus = 1:41;
perVertLeft_array_M_loves = 1:41;
perVertLeft_array_M_you = 1:41;
perVertLeft_array_M_time = 1:41;
perVertLeft_array_M_unforgiven = 1:41;
perVertLeft_array_M_elephant = 1:41;
perVertLeft_array_M_transparent = 1:41;
perVertLeft_array_M_is = 1:41;
perVertLeft_array_M_green = 1:41;
perVertLeft_array_M_math = 1:41;
perVertLeft_array_M_stop = 1:41;
perVertLeft_array_M_money = 1:41;
perVertLeft_array_M_jfk = 1:41;
perVertLeft_array_M_mouse = 1:41;
perVertLeft_array_M_brazil = 1:41;
perVertLeft_array_M_apple = 1:41;
perVertLeft_array_M_moose = 1:41;
perVertLeft_array_M_deer = 1:41;
perVertLeft_array_M_cool = 1:41;
perVertLeft_array_M_jacket = 1:41;

perVertLeft_array_F_A = 1:56;
perVertLeft_array_F_B = 1:56;
perVertLeft_array_F_E = 1:56;
perVertLeft_array_F_G = 1:56;
perVertLeft_array_F_H = 1:56;
perVertLeft_array_F_K = 1:56;
perVertLeft_array_F_M = 1:56;
perVertLeft_array_F_P = 1:56;
perVertLeft_array_F_jesus = 1:56;
perVertLeft_array_F_loves = 1:56;
perVertLeft_array_F_you = 1:56;
perVertLeft_array_F_time = 1:56;
perVertLeft_array_F_unforgiven = 1:56;
perVertLeft_array_F_elephant = 1:56;
perVertLeft_array_F_transparent = 1:56;
perVertLeft_array_F_is = 1:56;
perVertLeft_array_F_green = 1:56;
perVertLeft_array_F_math = 1:56;
perVertLeft_array_F_stop = 1:56;
perVertLeft_array_F_money = 1:56;
perVertLeft_array_F_jfk = 1:56;
perVertLeft_array_F_mouse = 1:56;
perVertLeft_array_F_brazil = 1:56;
perVertLeft_array_F_apple = 1:56;
perVertLeft_array_F_moose = 1:56;
perVertLeft_array_F_deer = 1:56;
perVertLeft_array_F_cool = 1:56;
perVertLeft_array_F_jacket = 1:56;
entropy_array_male = 1:28;
entropy_array_female = 1:28;

%% Cropping images and converting into binary (females):

% Class A
for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[256.5 427.5 207 96]);
imwrite(Im_crop,(str2mat(Sample_female_A1tif(count))));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_A(count) = entropy(A_binary);
binary_array_F_A(count) = nnz(A_binary);
perVertLeft_array_F_A(count) = (nnz(A_binary(1:56,:))./binary_array_F_A(count)).*100;
end 

% Class B
for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[580.5 418.5 255 114]);
imwrite(Im_crop,(str2mat(Sample_female_Btif(count))));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_B(count) = entropy(A_binary);
binary_array_F_B(count) = nnz(A_binary);
perVertLeft_array_F_B(count) = (nnz(A_binary(1:64,:))./binary_array_F_B(count)).*100;
%%

end 

% Class E
for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[913.5 421.5 255 114]);
imwrite(Im_crop,str2mat(Sample_female_Etif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_E(count) = entropy(A_binary);
binary_array_F_E(count) = nnz(A_binary);
perVertLeft_array_F_E(count) = (nnz(A_binary(1:64,:))./binary_array_F_E(count)).*100;

end 

% Class G
for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[1281.5 426.5 200 104]);
imwrite(Im_crop,str2mat(Sample_female_Gtif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_G(count) = entropy(A_binary);
binary_array_F_G(count) = nnz(A_binary);
perVertLeft_array_F_G(count) = (nnz(A_binary(1:64,:))./binary_array_F_G(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[253.5 650.5 224 100]);
imwrite(Im_crop,str2mat(Sample_female_Htif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_H(count) = entropy(A_binary);
binary_array_F_H(count) = nnz(A_binary);
perVertLeft_array_F_H(count) = (nnz(A_binary(1:64,:))./binary_array_F_H(count)).*100;

end 

for count = 1:1:56
Im_data = imread(cell2mat((Sample_females(count))));
imwrite(Im_data,cell2mat(Sample_female_jpg(count)));
Im_read = imread(cell2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[589.5 646.5 224 108]);
imwrite(Im_crop,cell2mat(Sample_female_Ktif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_K(count) = entropy(A_binary);
binary_array_F_K(count) = nnz(A_binary);
perVertLeft_array_F_K(count) = (nnz(A_binary(1:64,:))./binary_array_F_K(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[929.5 646.5 224 108]);
imwrite(Im_crop,str2mat(Sample_female_Mtif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_M(count) = entropy(A_binary);
binary_array_F_M(count) = nnz(A_binary);
perVertLeft_array_F_M(count) = (nnz(A_binary(1:64,:))./binary_array_F_M(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[1245.5 654.5 224 108]);
imwrite(Im_crop,str2mat(Sample_female_Ptif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_P(count) = entropy(A_binary);
binary_array_F_P(count) = nnz(A_binary);
perVertLeft_array_F_P(count) = (nnz(A_binary(1:64,:))./binary_array_F_P(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[269.5 862.5 224 108]);
imwrite(Im_crop,str2mat(Sample_female_jesus(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_jesus(count) = entropy(A_binary);
binary_array_F_jesus(count) = nnz(A_binary);
perVertLeft_array_F_jesus(count) = (nnz(A_binary(1:64,:))./binary_array_F_jesus(count)).*100;
end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[597.5 862.5 224 108]);
imwrite(Im_crop,str2mat(Sample_female_loves(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_loves(count) = entropy(A_binary);
binary_array_F_loves(count) = nnz(A_binary);
perVertLeft_array_F_loves(count) = (nnz(A_binary(1:64,:))./binary_array_F_loves(count)).*100;

end 
%%
for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[937.5 866.5 224 108]);
imwrite(Im_crop,str2mat(Sample_female_you(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_you(count) = entropy(A_binary);
binary_array_F_you(count) = nnz(A_binary);
perVertLeft_array_F_you(count) = (nnz(A_binary(1:64,:))./binary_array_F_you(count)).*100;

end 

for count = 1:1:56

Im_data = imread(str2mat((Sample_females(4))));
imwrite(Im_data,str2mat(Sample_female_jpg(4)));
Im_read = imread(str2mat(Sample_female_jpg(4)));
Im_crop = imcrop(Im_read,[1261.5 866.5 224 108]);
imwrite(Im_crop,str2mat(Sample_female_time(4)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_time(count) = entropy(A_binary);
binary_array_F_time(count) = nnz(A_binary);
perVertLeft_array_F_you(count) = (nnz(A_binary(1:64,:))./binary_array_F_time(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[237.5 1078.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_unforgiven(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_unforgiven(count) = entropy(A_binary);
binary_array_F_unforgiven(count) = nnz(A_binary);
perVertLeft_array_F_unforgiven(count) = (nnz(A_binary(1:64,:))./binary_array_F_unforgiven(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[585.5 1078.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_elephant(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_elephant(count) = entropy(A_binary);
binary_array_F_elephant(count) = nnz(A_binary);
perVertLeft_array_F_elephant(count) = (nnz(A_binary(1:64,:))./binary_array_F_elephant(count)).*100;
end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1082.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_transparent(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_transparent(count) = entropy(A_binary);
binary_array_F_transparent(count) = nnz(A_binary);
perVertLeft_array_F_transparent(count) = (nnz(A_binary(1:64,:))./binary_array_F_transparent(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[1229.5 1082.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_is(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_is(count) = entropy(A_binary);
binary_array_F_is(count) = nnz(A_binary);
perVertLeft_array_F_is(count) = (nnz(A_binary(1:64,:))./binary_array_F_is(count)).*100;
end 

% Class green:(change coordinates)
for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[241.5 1278.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_green(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_green(count) = entropy(A_binary);
binary_array_F_green(count) = nnz(A_binary);
perVertLeft_array_F_green(count) = (nnz(A_binary(1:64,:))./binary_array_F_green(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[573.5 1282.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_math(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_math(count) = entropy(A_binary);
binary_array_F_math(count) = nnz(A_binary);
perVertLeft_array_F_math(count) = (nnz(A_binary(1:64,:))./binary_array_F_math(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1278.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_stop(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_stop(count) = entropy(A_binary);
binary_array_F_stop(count) = nnz(A_binary);
perVertLeft_array_F_stop(count) = (nnz(A_binary(1:64,:))./binary_array_F_stop(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[1225.5 1278.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_money(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_money(count) = entropy(A_binary);
binary_array_F_money(count) = nnz(A_binary);
perVertLeft_array_F_money(count) = (nnz(A_binary(1:64,:))./binary_array_F_money(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[237.5 1482.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_jfk(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_jfk(count) = entropy(A_binary);
binary_array_F_jfk(count) = nnz(A_binary);
perVertLeft_array_F_jfk(count) = (nnz(A_binary(1:64,:))./binary_array_F_jfk(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[573.5 1482.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_mouse(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_mouse(count) = entropy(A_binary);
binary_array_F_mouse(count) = nnz(A_binary);
perVertLeft_array_F_mouse(count) = (nnz(A_binary(1:64,:))./binary_array_F_mouse(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1482.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_brazil(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_brazil(count) = entropy(A_binary);
binary_array_F_brazil(count) = nnz(A_binary);
perVertLeft_array_F_brazil(count) = (nnz(A_binary(1:64,:))./binary_array_F_brazil(count)).*100;
end 


for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[1229.5 1486.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_apple(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_apple(count) = entropy(A_binary);
binary_array_F_apple(count) = nnz(A_binary);
perVertLeft_array_F_apple(count) = (nnz(A_binary(1:64,:))./binary_array_F_apple(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[241.5 1714.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_moose(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_moose(count) = entropy(A_binary);
binary_array_F_moose(count) = nnz(A_binary);
perVertLeft_array_F_moose(count) = (nnz(A_binary(1:64,:))./binary_array_F_moose(count)).*100;

end 

for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[569.5 1714.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_deer(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_deer(count) = entropy(A_binary);
binary_array_F_deer(count) = nnz(A_binary);
perVertLeft_array_F_deer(count) = (nnz(A_binary(1:64,:))./binary_array_F_deer(count)).*100;

end 


for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1718.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_cool(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_cool(count) = entropy(A_binary);
binary_array_F_cool(count) = nnz(A_binary);
perVertLeft_array_F_cool(count) = (nnz(A_binary(1:64,:))./binary_array_F_cool(count)).*100;

end 


for count = 1:1:56
Im_data = imread(str2mat((Sample_females(count))));
imwrite(Im_data,str2mat(Sample_female_jpg(count)));
Im_read = imread(str2mat(Sample_female_jpg(count)));
Im_crop = imcrop(Im_read,[1233.5 1718.5 256 120]);
imwrite(Im_crop,str2mat(Sample_female_jacket(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_F_jacket(count) = entropy(A_binary);
binary_array_F_jacket(count) = nnz(A_binary);
perVertLeft_array_F_jacket(count) = (nnz(A_binary(1:64,:))./binary_array_F_jacket(count)).*100;
end 


%% Cropping images and converting into binary (males):
entropy_array_male = 1:28;
entropy_array = 1:41;
%%
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[256.5 427.5 207 96]);
imwrite(Im_crop,(str2mat(Sample_male_A1tif(count))));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_A(count) = entropy(A_binary);
binary_array_M_A(count) = nnz(A_binary);
perVertLeft_array_M_A(count) = (nnz(A_binary(1:56,:))./binary_array_M_A(count)).*100;

end 
%%
% Class B
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[580.5 418.5 255 114]);
imwrite(Im_crop,(str2mat(Sample_male_Btif(count))));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_B(count) = entropy(A_binary);
binary_array_M_B(count) = nnz(A_binary);
perVertLeft_array_M_B(count) = (nnz(A_binary(1:64,:))./binary_array_M_B(count)).*100;

end 

%%

% Class E
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[913.5 421.5 255 114]);
imwrite(Im_crop,str2mat(Sample_male_Etif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_E(count) = entropy(A_binary);
binary_array_M_E(count) = nnz(A_binary);
perVertLeft_array_M_E(count) = (nnz(A_binary(1:64,:))./binary_array_M_E(count)).*100;

end 

% Class G
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1281.5 426.5 200 104]);
imwrite(Im_crop,str2mat(Sample_male_Gtif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_G(count) = entropy(A_binary);
binary_array_M_G(count) = nnz(A_binary);
perVertLeft_array_M_G(count) = (nnz(A_binary(1:64,:))./binary_array_M_G(count)).*100;

end 

%Class H:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[253.5 650.5 224 100]);
imwrite(Im_crop,str2mat(Sample_male_Htif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_H(count) = entropy(A_binary);
binary_array_M_H(count) = nnz(A_binary);
perVertLeft_array_M_H(count) = (nnz(A_binary(1:64,:))./binary_array_M_H(count)).*100;

end 

% Class K:(change coordinates)
for count = 1:1:41
Im_data = imread(cell2mat((Sample_males(count))));
imwrite(Im_data,cell2mat(Sample_male_jpg(count)));
Im_read = imread(cell2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[589.5 646.5 224 108]);
imwrite(Im_crop,cell2mat(Sample_male_Ktif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_K(count) = entropy(A_binary);
binary_array_M_K(count) = nnz(A_binary);
perVertLeft_array_M_K(count) = (nnz(A_binary(1:64,:))./binary_array_M_K(count)).*100;

end 

% Class M:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[929.5 646.5 224 108]);
imwrite(Im_crop,str2mat(Sample_male_Mtif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_M(count) = entropy(A_binary);
binary_array_M_M(count) = nnz(A_binary);
perVertLeft_array_M_M(count) = (nnz(A_binary(1:64,:))./binary_array_M_M(count)).*100;

end 

% Class P:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1245.5 654.5 224 108]);
imwrite(Im_crop,str2mat(Sample_male_Ptif(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_P(count) = entropy(A_binary);
binary_array_M_P(count) = nnz(A_binary);
perVertLeft_array_M_P(count) = (nnz(A_binary(1:64,:))./binary_array_M_P(count)).*100;

end 

% Class jesus:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[269.5 862.5 224 108]);
imwrite(Im_crop,str2mat(Sample_male_jesus(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_jesus(count) = entropy(A_binary);
binary_array_M_jesus(count) = nnz(A_binary);
perVertLeft_array_M_jesus(count) = (nnz(A_binary(1:64,:))./binary_array_M_jesus(count)).*100;
end 

% Class loves:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[597.5 862.5 224 108]);
imwrite(Im_crop,str2mat(Sample_male_loves(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_loves(count) = entropy(A_binary);
binary_array_M_loves(count) = nnz(A_binary);
perVertLeft_array_M_loves(count) = (nnz(A_binary(1:64,:))./binary_array_M_loves(count)).*100;

end 
%%
% Class you:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[937.5 866.5 224 108]);
imwrite(Im_crop,str2mat(Sample_male_you(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_you(count) = entropy(A_binary);
binary_array_M_you(count) = nnz(A_binary);
perVertLeft_array_M_you(count) = (nnz(A_binary(1:64,:))./binary_array_M_you(count)).*100;

end 
%%
% Class time:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1261.5 866.5 224 108]);
imwrite(Im_crop,str2mat(Sample_male_time(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_time(count) = entropy(A_binary);
binary_array_M_time(count) = nnz(A_binary);
perVertLeft_array_M_time(count) = (nnz(A_binary(1:64,:))./binary_array_M_time(count)).*100;

end 

% Class unforgiven:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[237.5 1078.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_unforgiven(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_unforgiven(count) = entropy(A_binary);
binary_array_M_unforgiven(count) = nnz(A_binary);
perVertLeft_array_M_unforgiven(count) = (nnz(A_binary(1:64,:))./binary_array_M_unforgiven(count)).*100;

end 


% Class elephant:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[585.5 1078.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_elephant(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_elephant(count) = entropy(A_binary);
binary_array_M_elephant(count) = nnz(A_binary);
perVertLeft_array_M_elephant(count) = (nnz(A_binary(1:64,:))./binary_array_M_elephant(count)).*100;

end 

% Class transparent:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1082.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_transparent(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_transparent(count) = entropy(A_binary);
binary_array_M_transparent(count) = nnz(A_binary);
perVertLeft_array_M_transparent(count) = (nnz(A_binary(1:64,:))./binary_array_M_transparent(count)).*100;

end 
%%
% Class is:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1229.5 1082.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_is(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_is(count) = entropy(A_binary);
binary_array_M_is(count) = nnz(A_binary);
perVertLeft_array_M_is(count) = (nnz(A_binary(1:64,:))./binary_array_M_is(count)).*100;
end 
%%
% Class green:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[241.5 1278.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_green(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_green(count) = entropy(A_binary);
binary_array_M_green(count) = nnz(A_binary);
perVertLeft_array_M_green(count) = (nnz(A_binary(1:64,:))./binary_array_M_green(count)).*100;

end 

% Class math:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[573.5 1282.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_math(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_math(count) = entropy(A_binary);
binary_array_M_math(count) = nnz(A_binary);
perVertLeft_array_M_math(count) = (nnz(A_binary(1:64,:))./binary_array_M_math(count)).*100;

end 

% Class stop:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1278.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_stop(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_stop(count) = entropy(A_binary);
binary_array_M_stop(count) = nnz(A_binary);
perVertLeft_array_M_stop(count) = (nnz(A_binary(1:64,:))./binary_array_M_stop(count)).*100;

end 

% Class money:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1225.5 1278.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_money(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_money(count) = entropy(A_binary);
binary_array_M_money(count) = nnz(A_binary);
perVertLeft_array_M_money(count) = (nnz(A_binary(1:64,:))./binary_array_M_money(count)).*100;

end 

% Class jfk:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[237.5 1482.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_jfk(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_jfk(count) = entropy(A_binary);
binary_array_M_jfk(count) = nnz(A_binary);
perVertLeft_array_M_jfk(count) = (nnz(A_binary(1:64,:))./binary_array_M_jfk(count)).*100;

end 

% Class mouse:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[573.5 1482.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_mouse(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_mouse(count) = entropy(A_binary);
binary_array_M_mouse(count) = nnz(A_binary);
perVertLeft_array_M_mouse(count) = (nnz(A_binary(1:64,:))./binary_array_M_mouse(count)).*100;

end 

% Class brazil:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1482.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_brazil(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_brazil(count) = entropy(A_binary);
binary_array_M_brazil(count) = nnz(A_binary);
perVertLeft_array_M_brazil(count) = (nnz(A_binary(1:64,:))./binary_array_M_brazil(count)).*100;

end 

% Class apple:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1229.5 1486.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_apple(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_apple(count) = entropy(A_binary);
binary_array_M_apple(count) = nnz(A_binary);
perVertLeft_array_M_apple(count) = (nnz(A_binary(1:64,:))./binary_array_M_apple(count)).*100;

end 

%% Class moose:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[241.5 1714.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_moose(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_moose(count) = entropy(A_binary);
binary_array_M_moose(count) = nnz(A_binary);
perVertLeft_array_M_moose(count) = (nnz(A_binary(1:64,:))./binary_array_M_moose(count)).*100;

end 

%% Class deer:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[569.5 1714.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_deer(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_deer(count) = entropy(A_binary);
binary_array_M_deer(count) = nnz(A_binary);
perVertLeft_array_M_deer(count) = (nnz(A_binary(1:64,:))./binary_array_M_deer(count)).*100;

end 

% Class cool:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[909.5 1718.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_cool(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_cool(count) = entropy(A_binary);
binary_array_M_cool(count) = nnz(A_binary);
perVertLeft_array_M_cool(count) = (nnz(A_binary(1:64,:))./binary_array_M_cool(count)).*100;

end 

%% Class jacket:(change coordinates)
for count = 1:1:41
Im_data = imread(str2mat((Sample_males(count))));
imwrite(Im_data,str2mat(Sample_male_jpg(count)));
Im_read = imread(str2mat(Sample_male_jpg(count)));
Im_crop = imcrop(Im_read,[1233.5 1718.5 256 120]);
imwrite(Im_crop,str2mat(Sample_male_jacket(count)));
im1 = rgb2gray(Im_crop);
A_binary = imcomplement(imbinarize(im1));
entropy_array_M_jacket(count) = entropy(A_binary);
binary_array_M_jacket(count) = nnz(A_binary);
perVertLeft_array_M_jacket(count) = (nnz(A_binary(1:64,:))./binary_array_M_jacket(count)).*100;

end 



%% LDA Classification:
bad(:) =0;
rng(1)
X1_A = zeros(length(entropy_array_F_H)+length(entropy_array_M_H),2);
for i = 1:length(entropy_array_F_P)
   X1_A(i,1) = entropy_array_F_time(i); 
   X1_A(i,2) = perVertLeft_array_F_time(i);
end

for i = 57:97
    
   X1_A(i,1) = entropy_array_M_time(i-56);
   X1_A(i,2) = perVertLeft_array_M_time(i-56);
    
end

lda = fitcdiscr(X1_A(:,1:2),gender,'Prior','empirical');
ldaClass = resubPredict(lda);
ldaResubErr = resubLoss(lda)
[ldaResubCM,grpOrder] = confusionmat(gender,ldaClass);
kross = crossval(lda,'kfold',10);
kfoldLoss(kross)

figure;
bad = zeros(97,1);
gscatter(X1_A(:,1), X1_A(:,2),gender,'rgb','osd');

for i=1:97
    
    bad(i) = ~strcmp(ldaClass(i),gender(i));
end

bad = logical(bad);
hold on;
plot(X1_A(bad,1), X1_A(bad,2), 'kx');
hold on;

K = 0 ; L = 0;
K = lda.Coeffs(1,2).Const;
L = lda.Coeffs(1,2).Linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.05 0.45 0 100]);
hold off;

xlabel('Feature 1 : entropy')
ylabel('Feature 2 : % of pixels in upper Half')
title('LDA classification of Letter "A" ')
legend('female','male','misclassified','boundary')


%% LDA Classification of Letter B
bad(:) = 0;
rng default
X1_B = zeros(length(entropy_array_F_B)+length(entropy_array_M_B),2);
for i = 1:length(entropy_array_F_B)
   
X1_B(i,1) = entropy_array_F_B(i); 
X1_B(i,2) = perVertLeft_array_F_B(i);
end

for i = 57:97
    
X1_B(i,1) = entropy_array_M_B(i-56);

X1_B(i,2) = perVertLeft_array_M_B(i-56);
    
end

lda_B = fitcdiscr(X1_B(:,1:2),gender,'Prior','Uniform');
ldaClass_B = resubPredict(lda_B);
ldaResubErr_B = resubLoss(lda_B)
[ldaResubCM_B,grpOrder_B] = confusionmat(gender,ldaClass_B);


figure;
bad = zeros(97,1);
gscatter(X1_B(:,1), X1_B(:,2),gender,'rgb','osd');

for i=1:97
    
    bad(i) = ~strcmp(ldaClass_B(i),gender(i));
end
bad = logical(bad);
hold on;
plot(X1_B(bad,1), X1_B(bad,2), 'kx');
hold on;


K = lda_B.Coeffs(1,2).Const;
L = lda_B.Coeffs(1,2).Linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.05 0.45 0 100]);
hold off;

xlabel('Feature 1 : entropy')
ylabel('Feature 2 : % of pixels in upper Half')
title('LDA classification of Letter "B" ')
legend('female','male','misclassified','boundary')

%% QDA Classification:

X1 = zeros(length(entropy_array_F_time)+length(entropy_array_M_loves),2);
for i = 1:length(entropy_array_F_A)
   X1(i,1) = entropy_array_F_time(i); 
   X1(i,2) = perVertLeft_array_F_time(i);
end

for i = 57:97
    
   X1(i,1) = entropy_array_M_time(i-56);
   X1(i,2) = perVertLeft_array_M_time(i-56);
    
end

qda = fitcdiscr(X1(:,1:2),gender,'DiscrimType','quadratic','Prior','Uniform');
qdaResubErr = resubLoss(qda)
qdaClass = resubPredict(qda);

[qdaResubCM,grpOrder] = confusionmat(gender,qdaClass);

kross = crossval(qda,'kfold',10);
kfoldLoss(kross)

for i=1:97
    
    bad(i) = ~strcmp(qdaClass(i),gender(i));
end
bad = logical(bad);
figure;
gscatter(X1(:,1), X1(:,2),gender,'rgb','osd');

hold on;
plot(X1(bad,1), X1(bad,2), 'kx');
hold on

rng(0,'twister');
cp = cvpartition(gender,'KFold',2);

cvqda = crossval(qda,'CVPartition',cp);
qdaCVErr = kfoldLoss(cvqda);



K = qda.Coeffs(1,2).Const;
L = qda.Coeffs(1,2).Linear;
Q = qda.Coeffs(1,2).Quadratic;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 + ...
    (Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
h2 = ezplot(f,[.05 0.56 0 100]);
hold off;
xlabel('Feature 1 : Entropy')
ylabel('Feature 2: % of Black pixels in upper-half horizontal plane')
title('Classification of the word "time" using QDA with Prior Probab:Uniform')


%% kNN Classification

rng(5)
bad(:) = 0;
X1 = zeros(length(entropy_array_F_A)+length(entropy_array_M_A),2);
for i = 1:length(entropy_array_F_time)
   X1(i,1) = entropy_array_F_time(i); 
   X1(i,2) = perVertLeft_array_F_time(i);
end

for i = 57:97
    
   X1(i,1) = entropy_array_M_time(i-56);
   X1(i,2) = perVertLeft_array_M_time(i-56);
    
end


knnClassif = fitcknn(X1,gender,'NumNeighbors',21,'Standardize',1,'Prior','empirical');

knnResubErr = resubLoss(knnClassif)
knnClass = resubPredict(knnClassif);
[knnResubCM,grpOrder] = confusionmat(gender,knnClass);

cp = cvpartition(gender,'KFold',10);
knnDa = crossval(knnClassif,'CVPartition',cp);
kFold = kfoldLoss(knnDa)

for i=1:97
    
    bad(i) = ~strcmp(knnClass(i),gender(i));
end
bad = logical(bad);

figure;
gscatter(X1(:,1), X1(:,2),gender,'rgb','osd');

hold on;
plot(X1(bad,1), X1(bad,2), 'kx');
hold on


cp = cvpartition(gender,'KFold',2);

xlabel('Feature 1: Entropy')
ylabel('Feature 2 : % of black pixels in the horizontal upper half-plane')
title('Classification of word "time" using kNN,k=21')
legend('female','male','misclassified')

%% kNN Classification for Letter B


rng(5)
bad(:) = 0;
X1 = zeros(length(entropy_array_F_B)+length(entropy_array_M_B),2);
for i = 1:length(entropy_array_F_B)
   X1(i,1) = entropy_array_F_E(i); 
   X1(i,2) = perVertLeft_array_F_E(i);
end

for i = 57:97
    
   X1(i,1) = entropy_array_M_E(i-56);
   X1(i,2) = perVertLeft_array_M_E(i-56);
    
end


knnClassif = fitcknn(X1,gender,'NumNeighbors',2,'Standardize',1,'Prior','empirical');
knnResubErr = resubLoss(knnClassif)
knnClass = resubPredict(knnClassif);
[knnResubCM,grpOrder] = confusionmat(gender,knnClass);

for i=1:97
    
    bad(i) = ~strcmp(knnClass(i),gender(i));
end
bad = logical(bad);

figure;
gscatter(X1(:,1), X1(:,2),gender,'rgb','osd');

hold on;
plot(X1(bad,1), X1(bad,2), 'kx');
hold on


cp = cvpartition(gender,'KFold',2);

knnDa = crossval(knnClassif,'CVPartition',cp);
knnCVErr = kfoldLoss(knnDa);
xlabel('Feature 1: Entropy')
ylabel('Feature 2 : % of black pixels in the horizontal upper half-plane')
title('Classification of "Letter" using kNN,k = 2')
legend('female','male','misclassified')

%% kNN Classification k = 21

rng(5)
bad(:) = 0;
X1 = zeros(length(entropy_array_F_E)+length(entropy_array_M_E),2);
for i = 1:length(entropy_array_F_E)
   X1(i,1) = entropy_array_F_E(i); 
   X1(i,2) = perVertLeft_array_F_E(i);
end

for i = 57:97
    
   X1(i,1) = entropy_array_M_E(i-56);
   X1(i,2) = perVertLeft_array_M_E(i-56);
    
end


knnClassif = fitcknn(X1,gender,'NumNeighbors',21,'Standardize',1);
knnResubErr = resubLoss(knnClassif)
knnClass = resubPredict(knnClassif);
[knnResubCM,grpOrder] = confusionmat(gender,knnClass);

for i=1:97
    
    bad(i) = ~strcmp(knnClass(i),gender(i));
end
bad = logical(bad);

figure;
gscatter(X1(:,1), X1(:,2),gender,'rgb','osd');

hold on;
plot(X1(bad,1), X1(bad,2), 'kx');
hold on


cp = cvpartition(gender,'KFold',2);

knnDa = crossval(knnClassif,'CVPartition',cp);
knnCVErr = kfoldLoss(knnDa);
xlabel('Feature 1: Entropy')
ylabel('Feature 2 : % of black pixels in the horizontal upper half-plane')
title('Classification of "Letter" using kNN = 21')
legend('female','male','misclassified')

%% Naive Bayes Classification:


rng(5)
bad(:) = 0;
X1 = zeros(length(entropy_array_F_moose)+length(entropy_array_M_moose),2);
for i = 1:length(entropy_array_F_jacket)
   X1(i,1) = entropy_array_F_time(i); 
   X1(i,2) = perVertLeft_array_F_time(i);
end

for i = 57:97
    
   X1(i,1) = entropy_array_M_time(i-56);
   X1(i,2) = perVertLeft_array_M_time(i-56);
    
end

cp = cvpartition(gender,'KFold',10);
NaiveBay = fitcnb(X1(:,1:2),gender,'Distribution','Kernel','Prior','Empirical');
NaiveResubErr = resubLoss(NaiveBay)
NavClass = resubPredict(NaiveBay);


NBGauCV = crossval(NaiveBay,'CVPartition',cp);
kfold_Loss = kfoldLoss(NBGauCV)

figure;
labels = predict(NaiveBay,X1);
gscatter(X1(:,1),X1(:,2),labels,'grb','sod')


bad = 1:97;
for i=1:97
    
    bad(i) = ~strcmp(NavClass(i),gender(i));
end
bad = logical(bad);


hold on;
plot(X1(bad,1), X1(bad,2), 'bx','MarkerSize',15,'MarkerEdgeColor','b');
hold off;
kfoldLoss(NBGauCV);
legend('female','male','misclassif')

xlabel('Feature 1: Entropy')
ylabel('Feature 2:% of black pixels in the horizontal upper half-plane ')
title('Classification of sample word "time" using Naive Bayes')


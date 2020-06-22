dA = 0.016; %In m piston
dB = 0.010; %In m piston rod
AA = (pi/4)*dA^2; %area side A
AB = ((pi/4)*(dA^2))-((pi/4)*(dB^2)); %area side B

rcell = 2;
ccell = 4;
pcell = 10;
voltages = 5;
directions = 2;

result_cell = cell(rcell, ccell);

rows = [37581 12171 7981 7352 5991];
columns = 5;
pages = 10;

range_start = [6201 7001 3941 3090 2815];
range_end = [43781 19171 11921 10441 8805];

index_r = 1;
index_t = (rows(index_r)-1)/10000;

matrix1 = zeros(rows(index_r), columns, pages);
matrix_index = zeros(rows(index_r),1);




for index1 = 1:pages
    
    namefile = 'm_find_b_pA_1V_sample_%d.mat';
    strs = sprintf(namefile, index1);
    load(strs);
    
    p_t_ext = transpose(linspace(0,index_t,rows(index_r)));
    p_pA_ext = (10^6)*pressure_s_filtr1(range_start(index_r):(range_end(index_r)));
    p_poloha_s_filtr2_ext = 0.02*poloha_s_filtr2(range_start(index_r):(range_end(index_r)));
    p_poloha_s_filtr2_ext_V = poloha_s_filtr2(range_start(index_r):(range_end(index_r)));
    
    namefile = 'm_find_b_pB_1V_sample_%d.mat';
    strs = sprintf(namefile, index1);
    load(strs);
    
    p_pB_ext = (10^6)*pressure_s_filtr1(range_start(index_r):range_end(index_r));
    
    linea = polyfit(p_t_ext, p_poloha_s_filtr2_ext, 1);
    %matrix(rows,col,pages)
    matrix1(:,1,index1) = linea(1); %column speed
    matrix1(:,2,index1) = p_pA_ext; %column pA
    matrix1(:,3,index1) = p_pB_ext; %column pB
    matrix1(:,4,index1) = p_poloha_s_filtr2_ext; %column y(t)
    matrix1(:,5,index1) = (AA*p_pA_ext-AB*p_pB_ext)/linea(1); %column viscous friction b
    b = matrix1(:,5,index1); %column viscous friction b
    matrix_index(:,:) = 1; %matrix for plotting the voltage
    plot(p_poloha_s_filtr2_ext_V, b);
    grid on;
    grid minor;
    hold on;
    
    
end
b_total_mean = mean(mean(matrix1(:,5,:)));
C = zeros(size(p_poloha_s_filtr2_ext_V));
C(:)= b_total_mean;

hold on;
plot(p_poloha_s_filtr2_ext_V, C);
hold on;
b_string = sprintf("Average b is %.1f N*s/m. The input voltage is 1V.", b_total_mean);
legend(b_string);
xlabel('Output voltage y(t) [V]');
ylabel('Viscous friction b [N*s/m]');
title('Viscous friction b [N*s/m] by Output voltage [V]');
grid on;
grid minor;
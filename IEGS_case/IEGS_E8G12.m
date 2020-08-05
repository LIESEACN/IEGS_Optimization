function mp = IEGS_E8G12
    %% ת������
    % �ñ�׼��λ����MMBTU
    % conversion_constant;
    % MMBTU
    % 1 BTU - 0.293 Wh
    % 1 MMBTU = 0.293 MWh
    % 1 MMBTU = 28.3 SM3 
    % 1 Sm3 = 10.35 kWh     1 ��λ��Ȼ�� �൱�� ��10.35�ȵ� �۸�ת�� 1Ԫ/�ȵ� 10Ԫ 
    % 1 Sm3 = 0.01035 MWh  
    % [natural gas price ($/mmBtu) * heat rate (mmBtu/MWh)]
    % power price ($/MWh) 
    % One kWh has a heat content of 3,412 Btu. A generator that uses 7,000 Btu to produce one kWh has a conversion efficiency slightly below 50%.
    % eia.gov.sparkprice
    
    mp.convert.P2M = 1 / 0.293;
    mp.convert.G2M = 1 / 28.3;
    mp.convert.PS = 1 / 1;
    % mp.convert.G2M = 1 / 1;
    
    mp.ps.baseMVA = 100;
    %% power system data 
    % ������·(MW)
        %f  %t   %B(b.u) % capacity
    mp.ps.branch = [
        1,  2,  0.17,   150;
        1,  5,  0.17,   150;
        2,  3,  0.17,   150;
        2,  5,  0.17,   150;
        3,  4,  0.17,   150;
        3,  6,  0.17,   150;
        4,  7,  0.17,   150;
        4,  8,  0.17,   150;
        5,  6,  0.17,   150;
        6,  7,  0.17,   150;
        7,  8,  0.17,   150;];
    mp.ps.branch(:,4) = mp.ps.branch(:,4) / mp.ps.baseMVA;
    
        
    % ú�����(MW)
        %bus %Pmin %Pmax %Ramp(min)  
    mp.ps.coal_gen = [
        1,  50,  155;
        1,  80,    360;
        3,  50,  155;
        3,  80,    360;
    ];
    mp.ps.coal_gen(:,2:3) = mp.ps.coal_gen(:,2:3) / mp.ps.baseMVA;

    % ú�����ķ� ($/MW)
        %a*x^2 + b*x + c
        % a + b + c
    mp.ps.coal_cost = [
        0.008	9.1061	0;
        0.0035	11.9340	0;
        0.008	9.1061	0;
        0.1225	17.8123	0;
    ];

    % ȼ���������� (MW)
        %bus Pmin Pmax Ramp(min)
    mp.ps.gas_gen = [
        6,  19, 90;
        6,  51, 197;
    ];
    mp.ps.gas_gen(:,2:3) = mp.ps.gas_gen(:,2:3) / mp.ps.baseMVA;

    % ȼ������Ч��(%)
    mp.ps.gas_efficiency = [
        0.57;
        0.58;
    ];
    
    % P2G���� (MW)
        % bus , min, max
    mp.ps.p2g = [
        3,  0,  50;
        8,  0,  50;
    ];
    mp.ps.p2g(:,2:3) = mp.ps.p2g(:,2:3) / mp.ps.baseMVA;
    
    % P2Gת��Ч��,*\mu(%)
    mp.ps.p2g_efficiency = [
        49;
        55
    ];
    
    
    % �縺�ɵı�����������ݣ�24ʱ�Σ���һ���ļ�������
    % �ܸ���x�����ֵ�ÿ���ڵ㣬Ȼ�󱨼�����Ĭ����ͬ
    % [2,4,5,7,8] [0.14, 0.14, 0.24, 0.24, 0.24] 
    
    %% gas system data
    
    % ������ (SM3)
        %f  t  Capacity
    mp.gas.passive_pineline = [
        1,  2,  30000;
        2,  3,  30000;
        4,  7,  20000;
        4,  5,  30000;
        5,  6,  30000;
        3,  4,  30000;
        8,  9,  30000;
        9,  10, 20000;
        9,  11, 25000;
        9,  12, 30000;
    ];
    mp.gas.active_pineline = [
        4,  8,  35000;
    ];
    
    % ��Դ (SM3)
        % node  min  max
    mp.gas.source = [
        1,  0,  33000;
        4,  0,  34000;
        6,  0,  33000;
        12, 0,  33000;
    ];
    
    % ��Դ�ɱ� ($/SM3)
    mp.gas.source_cost = [
        0.6;
        0.5;
        0.7;
        0.6;
    ];

    % ȼ������ڵ�
    mp.gas.gas_gen_node = [
        1;
        5;
    ];
    
    % P2G���ڵ�
    mp.gas.p2g_node = [
        2;
        11;
    ];
    
    % ������
    % �������ֵ�ÿ���ڵ㣬������ͬ��
    % �ܸ���x�����ֵ�ÿ���ڵ㣬Ȼ�󱨼�����Ĭ����ͬ
    % [2,4,5,7,8] [0.14, 0.14, 0.24, 0.24, 0.24]
    

    %% �����������
    % �۸�ıȽ� ��Ľڵ��� / ���Ľڵ�����
    mp.mu_gas2power = [0.4; 0.45; 0.5];  % 3�����۵����ϵ��
    
    %% ��������
    % 24ʱ�� (MW)
    mp.ps.load = [
        500;480;460;450;455;475;510;580;610;655;685;705;720;725;730;750;758;732;728;710;707;680;600;586;
    ];
    mp.ps.load = mp.ps.load / mp.ps.baseMVA;

    % gas (SM3)
    mp.gas.load = [
        55000;49000;46000;46500;51000;56800;56200;61000;62000;62500;61500;61500;59400;57000;57500;58000;60400;62500;65600;67500;66000;65000;61000;55000;
    ];

    % ��������ת��Ĵ�С
    % LOAD G2P (MW)
    mp.gas.G2P_load = [
        0,  15,  15, 15;
        0,  15,  15, 15;
        0,  15,  15, 15;
        0,  10, 10, 10;
        0,  10, 10, 10;
    ];
    mp.gas.G2P_load = mp.gas.G2P_load / mp.ps.baseMVA;
    

    %% ��һ��
    % ���۹�һ�� ������һ
    % ps
    mp.ps.branch(:,4) = mp.ps.branch(:,4) * mp.convert.PS;
    mp.ps.coal_gen(:,2:3) = mp.ps.coal_gen(:,2:3) * mp.convert.PS;
    mp.ps.coal_cost(:,1) = mp.ps.coal_cost(:,1) * (1 / mp.convert.PS).^2;
    mp.ps.coal_cost(:,2) = mp.ps.coal_cost(:,2) * (1 / mp.convert.PS);
    mp.ps.gas_gen(:,2:3) = mp.ps.gas_gen(:,2:3) * mp.convert.PS;
    mp.ps.load = mp.ps.load * mp.convert.PS;
    mp.ps.p2g(:,2:3) = mp.ps.p2g(:,2:3) * mp.convert.PS;
    
    % gas
    mp.gas.passive_pineline(:,3) = mp.gas.passive_pineline(:,3) * mp.convert.G2M;
    mp.gas.active_pineline(:,3) = mp.gas.active_pineline(:,3) * mp.convert.G2M;
    mp.gas.source(:,2:3) = mp.gas.source(:,2:3) * mp.convert.G2M;
    mp.gas.source_cost = mp.gas.source_cost * (1 / mp.convert.G2M);
    mp.gas.load = mp.gas.load * mp.convert.G2M;
    mp.gas.G2P_load = mp.gas.G2P_load * mp.convert.PS;
    
    %% ���䵽�ڵ�
    % ���ɽڵ� 
    % [0.24, 0.24, 0.24, 0.14, 0.14]
    mp.ps.LoadNode = [
        2,  0.24;
        4,  0.24;
        5,  0.24;
        7,  0.14;
        8,  0.14;
    ];

    mp.gas.LoadNode = [
        3,  0.24;
        7,  0.24;
        8,  0.24;
        10, 0.14;
        11, 0.14;
    ];
    
    mp.ps.LoadinNode = mp.ps.LoadNode(:,2) * mp.ps.load';
    mp.gas.LoadinNode = mp.gas.LoadNode(:,2) * mp.gas.load';
    
    %% ����
    Price = 10 ./ mp.mu_gas2power;
    mp.ps.LoadBidding = BiddingFuncE(Price, mp.ps.LoadinNode, mp.gas.G2P_load);
    mp.gas.LoadBidding = BiddingFuncG(Price, mp.gas.LoadinNode, mp.gas.G2P_load, mp.mu_gas2power);
end


function B = BiddingFuncE(Price, E_Load, G2PofLoad)
    % scatter(mp.ps.LoadBidding{1,1}(1:2:7),mp.ps.LoadBidding{1,1}(2:2:8))
    % ���㱨�����ߣ�����(x,y)(x1,y1)(x2,y2)����ʽ
    [XShape, YShape] = size(E_Load);
    B = cell(XShape, YShape);
    X = cell(1,4);   % �洢���۵�x�����ݣ���ֶ��й�
    X{1} = E_Load - ones(XShape, YShape) .* sum(G2PofLoad(:,2:4),2);
    X{2} = E_Load - ones(XShape, YShape) .* sum(G2PofLoad(:,3:4),2);
    X{3} = E_Load - ones(XShape, YShape) .* G2PofLoad(:,4);
    X{4} = E_Load;
    % ����y
    Y = cell(1,4);  % �洢���۵�y�����ݣ���ֶ��й�
    Y{1} = X{1} .* Price(1);
    Y{2} = (X{2}-X{1}) .* Price(1) + Y{1};
    Y{3} = (X{3}-X{2}) .* Price(2) + Y{2};
    Y{4} = (X{4}-X{3}) .* Price(3) + Y{3};
    for i = 1:XShape
        for j = 1:YShape
            for k = 1:4
                B{i,j}(1,2*k-1) = X{k}(i,j);
                B{i,j}(1,2*k) = Y{k}(i,j);
            end
        end
    end
end

function B = BiddingFuncG(Price, G_Load, G2PofLoad, mu)
    % ��ȼ����������
    % ���㱨�����ߣ�����(x,y)(x1,y1)(x2,y2)����ʽ
    G2PofLoad(:,2:4) = G2PofLoad(:,2:4) ./ mu';
    [XShape, YShape] = size(G_Load);
    B = cell(XShape, YShape);
    X = cell(1,4);   % �洢���۵�x�����ݣ���ֶ��й�
    X{1} = G_Load;
    X{2} = G_Load + ones(XShape, YShape) .* G2PofLoad(:,4);
    X{3} = G_Load + ones(XShape, YShape) .* sum(G2PofLoad(:,3:4),2);
    X{4} = G_Load + ones(XShape, YShape) .* sum(G2PofLoad(:,2:4),2);
    % ����y
    Y = cell(1,4);  % �洢���۵�y�����ݣ���ֶ��й�
    Y{1} = X{1} .* Price(3);
    Y{2} = (X{2}-X{1}) .* Price(3) + Y{1};
    Y{3} = (X{3}-X{2}) .* Price(2) + Y{2};
    Y{4} = (X{4}-X{3}) .* Price(1) + Y{3};
    for i = 1:XShape
        for j = 1:YShape
            for k = 1:4
                B{i,j}(1,2*k-1) = X{k}(i,j);
                B{i,j}(1,2*k) = Y{k}(i,j);
            end
        end
    end
end
    
    
    
close all
clear
clc


%% ouverture du fichier et separation en blocks
fprintf(' \n %%%%%%%%%%%%%%%%%%%   DECRYPTAGE DU FICHIER.TXT  %%%%%%%%%%%%%%%%%%%%%%%%%% ')
fileID = fopen('draw2.txt','r');
Block = 1;
LINE_COL=1;
CIR_COL=1;
ARC_COL=1;
SOL_COL=1;
POLY_COL=1;
fprintf(' \n Debut de la partie de lecture ')
while (~feof(fileID))                         
   
   InputText = textscan(fileID,'%s',1,'delimiter','\n');
%% regroupement des lignes   
   if strcmp(InputText{1,1},'LINE')
       FullText = textscan(fileID,'%s',15,'delimiter','\n');
       Lines{1,LINE_COL} = InputText{1}{1,1};
       for a=1:size(FullText{1,1})
           Lines{1+a,LINE_COL} =FullText{1,1}{a,1};  
       end
       LINE_COL=LINE_COL+1;
       Block = Block+15;
    %% regroupement des cercles   
  elseif strcmp(InputText{1,1},'CIRCLE')
       FullText = textscan(fileID,'%s',13,'delimiter','\n');
       Circles{1,CIR_COL} = InputText{1}{1,1};
       for a=1:size(FullText{1,1})
           Circles{1+a,CIR_COL} =FullText{1,1}{a,1}; 
       end
       CIR_COL=CIR_COL+1;
       Block = Block+13;
    %% Regroupement des Section
  elseif strcmp(InputText{1,1},'ARC')
       FullText = textscan(fileID,'%s',17,'delimiter','\n');
       Arcs{1,ARC_COL} = InputText{1}{1,1};
       for a=1:size(FullText{1,1})
           Arcs{1+a,ARC_COL} =FullText{1,1}{a,1}; 
       end
       ARC_COL=ARC_COL+1;
       Block = Block+17;
       %% Regroupement des Solid
  elseif strcmp(InputText{1,1},'SOLID')
       FullText = textscan(fileID,'%s',23,'delimiter','\n');
       Solids{1,SOL_COL} = InputText{1}{1,1};
       for a=1:size(FullText{1,1})
           Solids{1+a,SOL_COL} =FullText{1,1}{a,1}; 
       end
       SOL_COL=SOL_COL+1;
       Block = Block+23;
%% Regroupement des polylines   
   elseif strcmp(InputText{1,1},'POLYLINE') 
       n=1;
       Polylines{n,POLY_COL}=InputText{1,1};
       while strcmp(InputText{1,1},'SEQEND')== false
           Block=Block+1;
           InputText = textscan(fileID,'%s',1,'delimiter','\n');
           n=n+1;
           Polylines{n,POLY_COL}=InputText{1,1};   
       end
       POLY_COL=POLY_COL+1;       
   end
   Block = Block+1; 
   
end
fprintf(' \n Fin de la partie de lecture \n')
% save Lines
% save Arcs
% save Circles
% save Solids
% save Polylines
fclose(fileID);

%% Etape de deplacement

M_DEP=[0,0,0,0,0,0];
%% Ajouter un deplacement initial

%% Deplacements LIGNES
fprintf(' \n %%%%%%%%%%%%%%%%%%%   ETUDE DES TRANSFORMATIONS ELEMENTAIRES  %%%%%%%%%%%%%%%%%%%%%%%%%% ')
fprintf([' \n On trace les lignes dans une image ',...
    '\n Il existe plusieurs types de lignes:',...
    '\n \t -CONTINUOUS  __________',...
    '\n \t -HIDDEN \t - - - - - ',...
    '\n \t -CENTER \t ____ _ ____ _ ',...
    '\n \t -PHANTOM \t _____ _ _ _____ _ _ \n'])
figure
hold on
grid off

fprintf(' \n Début etude des lignes ')

for a=1:LINE_COL-1
    x_ori=str2double(Lines(9,a));
    y_ori=str2double(Lines(11,a));
    x_end=str2double(Lines(13,a));
    y_end=str2double(Lines(15,a));
    M_DEP=[M_DEP;[x_ori,y_ori,x_end,y_end,0,0]];
    if strcmp(Lines{7,a},'CONTINUOUS')
        M_DEP(end,6)=1;
        line([x_ori,x_end],[y_ori,y_end],'Color','k','LineStyle','-')
    elseif strcmp(Lines{7,a},'HIDDEN')
        M_DEP(end,6)=2;
        line([x_ori,x_end],[y_ori,y_end],'Color','k','LineStyle','--')
    elseif strcmp(Lines{7,a},'CENTER')
        M_DEP(end,6)=3;
        line([x_ori,x_end],[y_ori,y_end],'Color','k','LineStyle','-.')
    elseif strcmp(Lines{7,a},'PHANTOM')
        M_DEP(end,6)=4;
        line([x_ori,x_end],[y_ori,y_end],'Color','k','LineStyle','-.')
    end
end

fprintf(' \n Fin etude des lignes ')
% Deplacements CERCLES
fprintf(' \n Début etude des cercles ')
for a=1:CIR_COL-1
    x_center=str2double(Circles(9,a));
    y_center=str2double(Circles(11,a));
    radius=str2double(Circles(13,a));
    M_DEP=[M_DEP;[x_center,y_center,x_center,y_center,radius,0]];
% line([x_center,x_center-radius],[y_center,y_center-radius],'Color',[230/255 230/255 230/255],'LineStyle','-')
    if strcmp(Circles{7,a},'CONTINUOUS')
       M_DEP(end,6)=1;
       rectangle('Position',[x_center-radius,y_center-radius,2*radius,2*radius],'Curvature',[1 1],'EdgeColor','k','LineStyle','-');
    elseif strcmp(Circles{7,a},'HIDDEN')
       M_DEP(end,6)=2;
        rectangle('Position',[x_center-radius,y_center-radius,2*radius,2*radius],'Curvature',[1 1],'EdgeColor','k','LineStyle','--');
    elseif strcmp(Circles{7,a},'CENTER')
        M_DEP(end,6)=3;
        rectangle('Position',[x_center-radius,y_center-radius,2*radius,2*radius],'Curvature',[1 1],'EdgeColor','k','LineStyle','-.');
    elseif strcmp(Circles{7,a},'PHANTOM')
        M_DEP(end,6)=4;
        rectangle('Position',[x_center-radius,y_center-radius,2*radius,2*radius],'Curvature',[1 1],'EdgeColor','k','LineStyle','-.');
    end
end
fprintf(' \n Fin etude des cercles ')
% Deplacements ARCS
fprintf(' \n Début etude des arcs ')
for a=1:ARC_COL-1
    x_center_ori=str2double(Arcs(9,a));
    y_center_ori=str2double(Arcs(11,a));
    radius=str2double(Arcs(13,a));
    Angle_ori=str2double(Arcs(15,a));
    Angle_end=str2double(Arcs(17,a));
    if Angle_end<Angle_ori
        Angle_end=Angle_end+360;
    end

if Angle_end<Angle_ori
    memo=Angle_end;
    Angle_end=Angle_ori;
    Angle_ori=memo;
end
M_DEP=[M_DEP;[x_center+radius*cos(Angle_ori*pi/180),y_center+radius*sin(Angle_ori*pi/180),...
              x_center+radius*cos(Angle_end*pi/180),y_center+radius*sin(Angle_ori*pi/180),1/radius,0]];
    if strcmp(Arcs{7,a},'CONTINUOUS')
         plot_arc(Angle_ori,Angle_end,x_center_ori,y_center_ori,radius,'-');
         M_DEP(end,6)=1;
    elseif strcmp(Arcs{7,a},'HIDDEN')
          plot_arc(Angle_ori,Angle_end,x_center_ori,y_center_ori,radius,'--');
          M_DEP(end,6)=2;
    elseif strcmp(Arcs{7,a},'CENTER')
         plot_arc(Angle_ori,Angle_end,x_center_ori,y_center_ori,radius,'-.');
          M_DEP(end,6)=3;
    elseif strcmp(Arcs{7,a},'PHANTOM')
         plot_arc(Angle_ori,Angle_end,x_center_ori,y_center_ori,radius,'-.');
          M_DEP(end,6)=4;
    end
end
fprintf(' \n Fin etude des arcs ')
%% Deplacements SOLIDS
fprintf(' \n Début etude des solides ')
for a=1:SOL_COL-1
    x_1=str2double(Solids(9,a));
    y_1=str2double(Solids(11,a));
    x_2=str2double(Solids(13,a));
    y_2=str2double(Solids(15,a));
    x_3=str2double(Solids(17,a));
    y_3=str2double(Solids(19,a));
    x_4=str2double(Solids(21,a));
    y_4=str2double(Solids(23,a));
M_DEP=[M_DEP;[x_1,y_1,x_2,y_2,0,0]];
M_DEP=[M_DEP;[x_2,y_2,x_3,y_3,0,0]];
M_DEP=[M_DEP;[x_3,y_3,x_4,y_4,0,0]];
M_DEP=[M_DEP;[x_4,y_4,x_1,y_1,0,0]];
X=[x_1;x_2;x_3;x_4];
Y=[y_1;y_2;y_3;y_4];
    if strcmp(Solids(7,a),'CONTINUOUS')
        M_DEP(end-3,6)=1;
        M_DEP(end-2,6)=1;
        M_DEP(end-1,6)=1;
        M_DEP(end,6)=1;
        fill(X,Y,'k')
    elseif strcmp(Solids(7,a),'HIDDEN')
        M_DEP(end-3,6)=2;
        M_DEP(end-2,6)=2;
        M_DEP(end-1,6)=2;
        M_DEP(end,6)=2;
        fill(X,Y,'k')
    elseif strcmp(Solids(7,a),'CENTER')
        M_DEP(end-3,6)=3;
        M_DEP(end-2,6)=3;
        M_DEP(end-1,6)=3;
        M_DEP(end,6)=3;
        fill(X,Y,'k')
    elseif strcmp(Solids(7,a),'PHANTOM')
        M_DEP(end-3,6)=4;
        M_DEP(end-2,6)=4;
        M_DEP(end-1,6)=4;
        M_DEP(end,6)=4;
        fill(X,Y,'k')
    end
end
fprintf(' \n Fin etude des solide ')
%% Ajouter un deplacement intermediaire

%% Deplacements polylignes
fprintf(' \n Début etude des polylines ')
for a=1:POLY_COL-1
POLY_X=[];
POLY_Y=[];
for b=1:size(Polylines,1)-1
    if strcmp(Polylines{b,a},'10')
        POLY_X=[POLY_X ; str2double(Polylines{b+1,a})];
    elseif strcmp(Polylines{b,a},'20')
        POLY_Y=[POLY_Y ; str2double(Polylines{b+1,a})];
    end
end
if size(POLY_X,1)>1
    for b=1:size(POLY_X,1)-1
    M_DEP=[M_DEP;[POLY_X(b),POLY_Y(b),POLY_X(b+1),POLY_Y(b+1),0,0]];
    if strcmp(Polylines{7,a},'CONTINUOUS')
        M_DEP(end,6)=1;
        plot(POLY_X,POLY_Y,'Color','black','LineStyle','-')
    elseif strcmp(Polylines{7,a},'HIDDEN')
        M_DEP(end,6)=2;
        plot(POLY_X,POLY_Y,'Color','black','LineStyle','--')
    elseif strcmp(Polylines{7,a},'CENTER')
        M_DEP(end,6)=3;
        plot(POLY_X,POLY_Y,'Color','black','LineStyle','-.')
    elseif strcmp(Polylines{7,a},'PHANTOM')
        M_DEP(end,6)=4;
        plot(POLY_X,POLY_Y,'Color','k','LineStyle','-.')
    end
    end
end
end
fprintf(' \n Fin etude des polylines ')
% %%
% OPTI_TRACER(M_DEP)
 disp('fini')

%% Maintenant il faut relier les points en mode tracer et entre les points sans tracer
%% Continuous ________ , hidden _ _ _ _ , CENTER ____ _ ____ _ , phantom ____ _ _ ____ , DOT . . . . , DASHED - - - - -
%% Le numero 62 reprensente la couleur pour le moment on change rien mais peut etre qu apres on pourra choisir de modifier la couleur
%% disp represente le deplacement en ecriture, inter_disp entre les phases et pen_write 1,a represente le type decriture alors que pen_write 2,a represente la position releve (0)

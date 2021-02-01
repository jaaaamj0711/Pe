# �ʿ��� ��Ű�� ��ġ
library(stringi)
library(stringr)
library(arules)
library(ggplot2)
library(readxl)
library(dplyr)
library(arulesViz)
# ������ �ҷ�����
pet<-read_xlsx("pet.xlsx")
pet<-data.frame(pet)

# �����跮 Ȯ��
summary(pet)

# ����ġ ����
pet<-na.omit(pet)

# ī�װ��� �и��ϱ�
category<-strsplit(pet$ī�װ�����,">")

# ��з��� �ش��ϴ� ù��°���� ��������
category_big<-unlist(lapply(category,function(dc){
  return(dc[1])}))

category_big<-data.frame(category_big,pet$�ֹ�����)
colnames(category_big)<-c("category","�ֹ�����")
# ����̿� �ɳ��̸� �����ϱ�
categoryd<-subset(category_big,category=="�����")
categoryc<-subset(category_big,category=="�ɳ���")
dogcat<-rbind(categoryc,categoryd)

# �ѱ��ŷ� ���ϱ�
big<-dogcat%>%
  group_by(category)%>%
  summarise(�ѱ��ŷ�=sum(�ֹ�����))

# �׷��� �׸��� 
ggplot(big,aes(x=category,y=�ѱ��ŷ�,fill=category))+geom_col()+xlab("��з�[�����&�ɳ���]")


# ��з� �׿ܿ� �͵� �����ϱ�
besides<-subset(cbesides,category!="�����")
besides<-subset(besides,category!="�ɳ���")

# �ѱ��ŷ� ���ϱ�
big_1<-besides%>%
  group_by(category)%>%
  summarise(�ѱ��ŷ�=sum(�ֹ�����))

# �׷��� �׸���
ggplot(big_1,aes(x=category,y=�ѱ��ŷ�,fill=category))+geom_col()+xlab("��з�[�׿�]")


# �ֹ��Ͻÿ��� " " �������� �и� 
time<-strsplit(pet$�ֹ��Ͻ�," ")

# �ֹ��Ͻÿ��� �ð��� �ش��ϴ� �κи� ��������
time<-unlist(lapply(time,function(t){
  return(t[2])}))

# �տ� �α��ڸ� ��������(���� ����)
time<-substr(time,1,2)
time_result<-data.frame(time,pet$�ֹ�����)
colnames(time_result)<-c("time","�ֹ�����")

# �ð��� ���� �ѱ��ŷ� ���ϱ�
time_count<-time_result%>%
  group_by(time)%>%
  summarise(�ѱ��ŷ�=sum(�ֹ�����))

# �׷��� �׸���
ggplot(time_count,aes(x=time,y=�ѱ��ŷ�,fill=time))+geom_col()+xlab("�ð�")

# ������¥&�����ð��� �Һ��ڰ� ������ ��ǰ�� �˾ƺ��� ���� �ֹ��Ͻÿ� �ӽð�����ȣ�� ��ħ
pastepet<-paste(pet$�ֹ��Ͻ�,pet$�ӽð�����ȣ)

# pastepet���� ��ǰ�ڵ带 �з��ؼ� ������ ��� ��ǰ�� �����ߴ����� Ȯ��
pet_list<-split(pet$��ǰ�ڵ�,pastepet)

# arules�Լ� ����� ���� transction���·� ����
pet_trans<-as(pet_list,'transactions')
summary(pet_trans)  

# support(������)�� �������� ������ ��Ģ�� 0�� �����Ǵ� ����� support���� ���� ���� ����.
pet_rules<-apriori(pet_trans,parameter =list(supp=0.0005))
summary(pet_rules)
inspect(pet_rules)


# �ð�ȭ 1
plot(pet_rules,method="paracoord")
# �ð�ȭ 2
plot(pet_rules,method='graph',control = list(type='items'),vertex.label.cex=0.7,edge.arrow.size=0.3,edge.arrow.width=2)

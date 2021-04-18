

# Load packages -----------------------------------------------------------

library(tidyverse)
library(corrgram)
library(ggthemes)
library(party)
library(caret)
library(randomForest)
library(plotly)
library(htmlwidgets)

# Import Data -------------------------------------------------------------

commute_data_raw <- read.csv("data/commute_data.csv")
hr_performance_data_raw <- read.csv("data/hr_employees_performance_data.csv")
personal_data_raw <- read.csv("data/personal_data.csv", stringsAsFactors = FALSE)
rnd_performance_data_raw <- read.csv("data/research_and_development_employees_performance_data.csv")
sales_performance_data_raw <- read.csv("data/sales_employees_performance_data.csv")



# Data Clean-up -----------------------------------------------------------------


 
personel_data <- personal_data_raw %>%
  spread(key = Variable, value = Value) %>%
  mutate(Age= as.integer(Age),
         Attrition=as.factor(Attrition),
         Education=as.integer(Education),
         EducationField=as.factor(EducationField),
         Gender=as.factor(Gender),
         MaritalStatus=as.factor(MaritalStatus),
         RelationshipSatisfaction=as.integer(RelationshipSatisfaction)) %>%
  select(-EmployeeCount)


hr_performance_data <- select(hr_performance_data_raw, -X)
rnd_performance_data <- select(rnd_performance_data_raw, -X)
sales_performance_data <- select(sales_performance_data_raw, -X)
commute_data <- select(commute_data_raw, -X)


hr_performance_data$Department <- "HR"
rnd_performance_data <- mutate(rnd_performance_data, Department="Research and development")
sales_performance_data <- sales_performance_data %>%
  mutate(Department="Sales")

performance_data <- rbind(hr_performance_data, rnd_performance_data, sales_performance_data)
performance_data <- performance_data %>%
  mutate(Department=as.factor(Department))


employee_data <- left_join(performance_data, commute_data, by="EmployeeNumber")
employee_data <- inner_join(employee_data,  personel_data, by="EmployeeNumber")


employee_data <- performance_data %>%
  left_join(commute_data, by="EmployeeNumber") %>%
  left_join(personel_data, by="EmployeeNumber")


rates <- employee_data %>%
  select(DailyRate, HourlyRate, MonthlyRate, MonthlyIncome)

corrgram(rates, upper.panel = panel.conf, lower.panel = panel.pts)



# Tables and Graphs -------------------------------------------------------
#att by gender
a1 <- employee_data %>%
  select(Gender, Attrition) %>%
  group_by(Gender, Attrition) %>%
  summarise(Count=n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(percentAttrition = Yes/(Yes+No))
a1

#att by gender by department
a2 <- employee_data %>%
  select(Gender, Attrition, Department) %>%
  group_by(Department, Gender, Attrition) %>%
  summarise(Count=n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(percentAttrition = Yes/(Yes+No))
a2

#over 40
over_forty <- employee_data %>%
  filter(Age>40)
a3 <- over_forty %>%
  select(Gender, Attrition, Department) %>%
  group_by(Department, Gender, Attrition) %>%
  summarise(Count=n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(percentAttrition = Yes/(Yes+No))
a3

#commute stuff
a4 <- employee_data %>%
  select(Attrition, DistanceFromHome) %>%
  group_by(Attrition) %>%
  summarise(AvgDist = mean(DistanceFromHome),
            StdDec = sd(DistanceFromHome))

write.csv(a4,"Commute_attrition.csv", row.names = FALSE)

p1 <- ggplot(data = employee_data, aes(x= Attrition, y=HourlyRate)) + geom_boxplot()

p2 <- ggplot(data = employee_data, aes(x= Attrition, y=HourlyRate, fill=Department)) + geom_boxplot()
p2

p3 <- ggplot(data = employee_data, aes(x= HourlyRate, fill=Attrition)) + 
  geom_histogram(alpha=0.4) + 
  facet_wrap(~Department, ncol = 1) +
  scale_fill_fivethirtyeight()
p3


p4 <- ggplot(data = employee_data, aes(x=Age, y=YearsAtCompany)) +
  geom_point(aes(color=Attrition)) +
  geom_smooth()
p4


p5 <- ggplot(data = employee_data, aes(x= Attrition, fill=as.factor(PerformanceRating))) +
  geom_bar(position = "dodge")
p5




# Model -------------------------------------------------------------------



employee_data <- employee_data %>%
  mutate(EnvironmentSatisfaction=as.factor(EnvironmentSatisfaction),
         JobInvolvement=as.factor(JobInvolvement),
         JobLevel=as.factor(JobLevel),
         JobSatisfaction = as.factor(JobSatisfaction),
         PerformanceRating = as.factor(PerformanceRating),
         StockOptionLevel=as.factor(StockOptionLevel),
         WorkLifeBalance=as.factor(WorkLifeBalance),
         Education=as.factor(Education),
         RelationshipSatisfaction =as.factor(RelationshipSatisfaction),
         BusinessTravel=as.factor(BusinessTravel),
         JobRole=as.factor(JobRole),
         Over18=as.factor(Over18),
         OverTime = as.factor(OverTime))

dataSpliter <- function(employee_data, p=0.7){
  set.seed(10)
  num_obs <- dim(employee_data)[1] 
  draw <- sample(1:num_obs, replace = FALSE)
  draw_split <- floor(num_obs * p)
  train <- employee_data[draw[1:draw_split],]
  test <- employee_data[draw[(draw_split +1):num_obs],]
  result <- list(train = train, test= test)
  return(result)
}


employee_allsets <- dataSpliter(employee_data, p=0.7)
employee_trainset <- employee_allsets$train
employee_testset <- employee_allsets$test


# 
# train_ctree <- ctree(data = employee_trainset, formula = Attrition ~ BusinessTravel +
#                        DailyRate +
#                        EnvironmentSatisfaction +
#                        JobInvolvement)
# 
# predict_ctree <- predict(train_ctree, employee_testset)
# confusionMatrix(predict_ctree, employee_testset$Attrition)

train_ctree <- ctree(data = employee_trainset, formula = Attrition ~ .)

predict_ctree <- predict(train_ctree, employee_testset)
confusionMatrix(predict_ctree, employee_testset$Attrition)
plot(train_ctree)


rand_forest <- randomForest(data=employee_trainset, Attrition ~., importance=TRUE)
predict_forest <- predict(rand_forest, employee_testset)
confusionMatrix(predict_forest, employee_testset$Attrition)
importance(rand_forest)


p1 <- ggplot(data = employee_data)+
  geom_bar(aes(x=OverTime, fill=Attrition), position="fill") +
  ggtitle("Percentage Attrition by OverTime") +
  scale_fill_colorblind()
p1
           
dp1 <- ggplotly(p1)

saveWidget(dp1,file = "att_vs_overtime.html")
pdf("att_v_overtime.pdf")
p1
dev.off()


p2 <- ggplot(data = employee_data)+
  geom_bar(aes(x=StockOptionLevel, fill=Attrition), position="fill") +
  ggtitle("Percentage Attrition by Stock Option Level") +
  scale_fill_colorblind()
p2
pdf("attrition_vs_stockoption.pdf")
p2
dev.off()


employees_current <- employee_data %>%
  filter(Attrition == "No")

current_prediction_ctree <- predict(train_ctree, employees_current)
employees_current$PredictedAttrition <- current_prediction_ctree
likely_to_leave_list1 <- employees_current %>%
  filter(PredictedAttrition=="Yes")

current_prediction_forest <- predict(rand_forest, employees_current)
employees_current$PredictedAttrition2 <- current_prediction_forest
likely_to_leave_list2 <- employees_current %>%
  filter(PredictedAttrition2 == "Yes")

write.csv(x=likely_to_leave_list1, "ctree_model_likely_to_leave.csv", row.names = FALSE)
write.csv(x=likely_to_leave_list2, "randForest_model_likely_to_leave.csv", row.names = FALSE)
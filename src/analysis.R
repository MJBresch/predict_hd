library(tidyverse)
library(randomForest)


# Load and tidy the data
heart_raw <- read.csv("data/raw_data/Heart.csv")

# remove column X, and any missing data points
heart_clean <- select(heart_raw, -X)
heart_clean <- drop_na(heart_clean)
write.csv(heart_clean, "data/clean_data/heart.clean.csv")

# Split cohort in two: train and test

train <- sample(1:nrow(heart_clean), nrow(heart_clean)* 0.7)
test <- -train

# Train random forest model

fit <- randomForest(AHD ~ ., data = heart_clean, subset = train, 
                    importance = TRUE, keep.forest = TRUE, 
                    xtest = heart_clean[test, -ncol(heart_clean)],
                    ytest = heart_clean[test, "AHD"])

# Save the results
saveRDS(fit, "results/random_forest_fit.rds")
print(fit)
plot(fit)


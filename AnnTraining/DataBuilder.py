import torch
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from torch.utils.data import DataLoader, TensorDataset
import kagglehub # make sure you use command "pip install kagglehub" to install this package
import kagglehub
import os

# Set the directory to download the dataset
download_dir = "AnnTraining/Dataset"  

# Ensure the directory exists
os.makedirs(download_dir, exist_ok=True)

# Download dataset to the specified directory
dataset_path = kagglehub.dataset_download("mathchi/diabetes-data-set", download_dir=download_dir)

# Construct the path to the CSV file
file_path = os.path.join(dataset_path, "diabetes.csv") 

# Print the path to the CSV file **for debugging purposes**
print(f"Dataset downloaded to: {file_path}")
print(f"Dataset downloaded to: {dataset_path}")

class DataBuilder:
    def __init__(self, file_path=file_path, batch_size=32):
        data = pd.read_csv(file_path)

        # Separate features and target
        self.X = data.iloc[:, :-1].values  # All columns except the last one
        self.Y = data.iloc[:, -1].values   # The last column (Outcome)

        # Store input size for model
        self.input_size = self.X.shape[1]  # Number of features

        # Split dataset (80% training, 20% testing)
        X_train, X_test, Y_train, Y_test = train_test_split(self.X, self.Y, test_size=0.2, random_state=42)

        # Normalize the features
        scaler = StandardScaler()
        self.X_train = scaler.fit_transform(X_train)
        self.X_test = scaler.transform(X_test)

        # Convert to PyTorch tensors
        self.X_train_tensor = torch.tensor(self.X_train, dtype=torch.float32)
        self.Y_train_tensor = torch.tensor(Y_train, dtype=torch.float32).unsqueeze(1)
        self.X_test_tensor = torch.tensor(self.X_test, dtype=torch.float32)
        self.Y_test_tensor = torch.tensor(Y_test, dtype=torch.float32).unsqueeze(1)

        # Create data loaders
        self.train_dataset = TensorDataset(self.X_train_tensor, self.Y_train_tensor)
        self.test_dataset = TensorDataset(self.X_test_tensor, self.Y_test_tensor)

        self.train_loader = DataLoader(self.train_dataset, batch_size=batch_size, shuffle=True)
        self.test_loader = DataLoader(self.test_dataset, batch_size=batch_size, shuffle=False)

    def get_input_size(self):
        """Returns the number of features in the dataset"""
        return self.input_size

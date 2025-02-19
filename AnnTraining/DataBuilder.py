import torch
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from torch.utils.data import DataLoader, TensorDataset

class DataBuilder:
    def __init__(self, file_path, batch_size=32):
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

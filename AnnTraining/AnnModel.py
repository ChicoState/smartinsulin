import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

class DiabetesModel(nn.Module):
    
    def __init__(self, input_size):
        super(DiabetesModel, self).__init__()
        # Define the layers of the model (3 layers) "input_size" is the number of features in the dataset
        # The first layer has 16 neurons, the second layer has 8 neurons, and the output layer has 1 neuron
        # The activation function for the first two layers is ReLU, and the output layer uses a sigmoid activation function
        # The sigmoid function is used to convert the output to a probability value between 0 and 1
        # **We plan to ajust the number of neurons in each layer to improve the model's performance**
        self.fc1 = nn.Linear(input_size, 16) 
        self.fc2 = nn.Linear(16, 8)
        self.fc3 = nn.Linear(8, 1)
        self.relu = nn.ReLU()
        self.sigmoid = nn.Sigmoid()
    
    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.relu(self.fc2(x))
        x = self.sigmoid(self.fc3(x))
        return x
    
    # Training function
    def train (self, train_loader, epochs):
        # Define the loss function and optimizer
        criterion = nn.BCELoss()
        optimizer = optim.Adam(self.parameters(), lr=0.001)
        
        # Move the model to the appropriate device (GPU or CPU)
        self.to(device)
        for epoch in range(epochs):
            self.train()
            running_loss = 0.0
            for inputs, labels in train_loader:
                inputs, labels = inputs.to(device), labels.to(device)
                optimizer.zero_grad()
                outputs = self.model(inputs)
                loss = criterion(outputs, labels)
                loss.backward()
                optimizer.step()
                running_loss += loss.item()
            
            print(f"Epoch {epoch+1}/{epochs}, Loss: {running_loss/len(train_loader):.4f}")
    
    # Evaluation function        
    def evaluate(self, test_loader):
        self.eval()
        y_pred = []
        y_true = []
        with torch.no_grad():
            for inputs, labels in test_loader:
                inputs, labels = inputs.to(device), labels.to(device)
                outputs = self(inputs)
                y_pred.extend(outputs.cpu().numpy())
                y_true.extend(labels.cpu().numpy())

        # Convert predictions to binary values
        y_pred = np.array(y_pred) > 0.5
        accuracy = np.mean(y_pred == y_true)
        print(f"Test Accuracy: {accuracy:.4f}")
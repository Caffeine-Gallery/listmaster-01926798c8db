import { backend } from 'declarations/backend';

const addItemForm = document.getElementById('add-item-form');
const itemInput = document.getElementById('item-input');
const shoppingList = document.getElementById('shopping-list');

async function loadItems() {
  const items = await backend.getAllItems();
  shoppingList.innerHTML = '';
  items.forEach(item => {
    const li = createListItem(item);
    shoppingList.appendChild(li);
  });
}

function createListItem(item) {
  const li = document.createElement('li');
  li.innerHTML = `
    <input type="checkbox" ${item.completed ? 'checked' : ''}>
    <span class="${item.completed ? 'completed' : ''}">${item.name}</span>
    <button class="delete-btn"><i class="fas fa-trash"></i></button>
  `;

  const checkbox = li.querySelector('input[type="checkbox"]');
  checkbox.addEventListener('change', async () => {
    await backend.updateItem(item.id, checkbox.checked);
    await loadItems();
  });

  const deleteBtn = li.querySelector('.delete-btn');
  deleteBtn.addEventListener('click', async () => {
    await backend.deleteItem(item.id);
    await loadItems();
  });

  return li;
}

addItemForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  const itemName = itemInput.value.trim();
  if (itemName) {
    await backend.addItem(itemName);
    itemInput.value = '';
    await loadItems();
  }
});

// Load items when the page loads
window.addEventListener('load', loadItems);

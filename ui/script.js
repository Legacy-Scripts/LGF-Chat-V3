let chatInputTimeout;
let chatClosedByUser = false;
let isChatDragging = false;
let offset = { x: 0, y: 0 };

let playerId;
let playerName;
let content;
let job;

const chatSuggestions = document.getElementById("suggestion-container");


window.addEventListener('message', (event) => {
    let data = event.data;

    if (data.action === 'showChatMain') {
        playerId = data.playerData.playerId;
        playerName = data.playerData.playerName;
        job = data.playerData.playerJob;
        openChat();
    } else if (data.action === 'sendMessage') {
        let playerName = data.author;
        let messageText = data.message;
        let job = data.playerJob;
        let playerId = data.playerId;
        let bgcolor = data.bgcolor
        let icon = data.icon
        const chatMessages = document.getElementById('chat-messages');
        const suggestionContainer = document.getElementById('suggestion-container');
        const chatInput = document.getElementById('chat-input');
        const messageElement = createMessageElement(playerName, messageText, playerId, job, bgcolor, icon);
        chatMessages.appendChild(messageElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;
        chatInput.value = '';
        resetChatInputTimeout();
        suggestionContainer.classList.remove('visible');
        // setTimeout(() => {
        //     closeChat();
        // }, 5000);
    } else if (data.action === "addSugestion") {
        if (!data.suggestion.name) return;

        suggestions[data.suggestion.name] = {
            help: data.suggestion.help,
            params: data.suggestion.params
        };
    } else if (data.action === 'ConsolePrint') {
        let playerName = 'System';
        let messageText = data.Message.content;
        let job = '';
        let playerId = '';
        let icon = 'info-circle'; 
    
        if (messageText.trim() !== '') { 
            const chatMessages = document.getElementById('chat-messages');
            const chatInput = document.getElementById('chat-input');
            const messageElement = createMessageElement(playerName, messageText, playerId, job, '', icon);
            chatMessages.appendChild(messageElement);
            chatMessages.scrollTop = chatMessages.scrollHeight;
            chatInput.value = '';
            resetChatInputTimeout();
        }
        
    }
});

function GenerateSuggestions() {
    const chatInput = document.getElementById('chat-input');

    if (chatInput.value.charAt(0) != "/" || chatInput.value.length == 1) {
        chatSuggestions.style.display = "none";
        return;
    }
    const args = chatInput.value.split(" ");
    for (let i = 0; i < args.length; i++)args[i] = args[i].toLowerCase();
    chatSuggestions.innerHTML = "";
    for (const name in suggestions) {
        2
        if (args.length > 1 ? name == args[0] : name.startsWith(args[0])) {
            let params = "", curHelp = suggestions[name].help;
            for (let i = 0; i < (suggestions[name].params ? suggestions[name].params.length : 0); i++) {
                params += ` <span${args.length - 1 > i ? ` style="color: white">` : ">"}[${suggestions[name].params[i].name}]</span>`;
                if (args.length - 2 == i) curHelp = suggestions[name].params[i].help;
            }
            chatSuggestions.innerHTML += `<div class="suggestion">
            <div class="suggestion_command"><span style="color: white">${args[0]}</span>${name.replaceAll(args[0], "")}${params}</div>
            <div class="suggestion_desc">${curHelp}</div>
        </div>`;
        }
    }
    chatSuggestions.style.display = chatSuggestions.innerHTML == "" ? "none" : "block";
}

$("#chat-input").on("input", GenerateSuggestions);

document.addEventListener('DOMContentLoaded', () => {
    const chatForm = document.getElementById('chat-form');
    const chatInput = document.getElementById('chat-input');
    const settingsButton = document.querySelector('.settings-btn');

    settingsButton.addEventListener('mousedown', startDrag);

    chatForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const messageText = chatInput.value.trim();
        if (messageText !== '') {
            $.post(`https://${GetParentResourceName()}/sendMessage`, JSON.stringify({
                message: messageText,
            }));
            if (messageText.startsWith("/")) {
                closeChat()
            }
        }
    });

    chatInput.addEventListener('focus', () => {
        clearTimeout(chatInputTimeout);
    });
});

let lastMsg = [];
let curLastMsg = 0;
let suggestions = {};

function openChat() {
    const chatBody = document.body;
    if (chatBody.style.display !== 'none' && chatBody.classList.contains('visible')) {
        return; 
    }

    document.getElementById('chat-input').value = '';
    chatBody.style.display = 'block';
    chatBody.style.animation = 'fadeIn 0.5s ease';
    // resetChatInputTimeout();
    chatClosedByUser = false;

    const chatInputEl = document.getElementById('chat-input');
    chatInputEl.focus();
}


function closeChat() {
    const suggestionContainer = document.getElementById('suggestion-container');
    document.body.addEventListener('animationend', function (event) {
        if (event.animationName === 'fadeOut') {
            document.body.style.display = 'none';
            document.body.classList.remove('visible');
            chatClosedByUser = true;
            suggestionContainer.classList.remove('visible');

            suggestionContainer.style.display = 'none';
        }
    }, { once: true });
    document.body.style.animation = 'fadeOut 0.5s ease forwards';
    $.post(`https://${GetParentResourceName()}/closeChat`, JSON.stringify({}));
}


window.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        closeChat();
    }
});

function resetChatInputTimeout() {
    clearTimeout(chatInputTimeout);
    chatInputTimeout = setTimeout(() => {
        if (!chatClosedByUser) {
            closeChat()
        }
    }, 5000);
}

function createMessageElement(user, text, playerId, job, bgcolor, icon) {
    const messageDiv = document.createElement('div');
    messageDiv.classList.add('message');

    if (bgcolor) {
        messageDiv.style.background = bgcolor;
    }
    

    const typeIcon = document.createElement('div');
    typeIcon.classList.add('icon');

    const iconElement = document.createElement('i');
    iconElement.classList.add('fa', `fa-${icon}`);
    typeIcon.appendChild(iconElement);

    const userBoxDiv = document.createElement('div');
    userBoxDiv.classList.add('user-box');
    userBoxDiv.textContent = user;

    const messageContentDiv = document.createElement('div');
    messageContentDiv.classList.add('message-content');
    const textSpan = document.createElement('span');
    textSpan.classList.add('text');
    textSpan.textContent = text;

    const timestamp = document.createElement('span'); 
    timestamp.classList.add('timestamp');
    const now = new Date();
    timestamp.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    const metaDiv = document.createElement('div');
    metaDiv.classList.add('meta-info');

    if (playerId) {
        const playerIdSpan = document.createElement('span');
        playerIdSpan.classList.add('player-id');
        playerIdSpan.textContent = 'ID ' + playerId;
        metaDiv.appendChild(playerIdSpan);
    }

    if (job) {
        const jobDiv = document.createElement('div');
        jobDiv.classList.add('user-job');
        jobDiv.textContent = job;
        metaDiv.appendChild(jobDiv);
    }

    messageDiv.appendChild(typeIcon);
    metaDiv.appendChild(timestamp);
    messageContentDiv.appendChild(textSpan);
    messageDiv.appendChild(userBoxDiv);
    messageDiv.appendChild(messageContentDiv);
    messageDiv.appendChild(metaDiv);
    messageDiv.style.opacity = '3';

    setTimeout(() => {
        messageDiv.style.transition = 'opacity 0.9s ease';
        messageDiv.style.opacity = '1';
    }, 200);
    
    openChat();
    return messageDiv;
}


window.addEventListener('message', (event) => {
    let data = event.data;
    if (data.action == 'clearChat') {
        clearChat();
    }
});

function clearChat() {
    const chatMessages = document.getElementById('chat-messages');
    chatMessages.innerHTML = '';
}

const chatInputEl = document.getElementById('chat-input');
const suggestionContainerEl = document.getElementById('suggestion-container');

chatInputEl.addEventListener('input', () => {
    const inputValue = chatInputEl.value.trim().toLowerCase();
    if (inputValue) {
        suggestionContainerEl.classList.add('visible');
    } else {
        suggestionContainerEl
        suggestionContainerEl.classList.remove('visible');
    }
});

suggestionContainerEl.addEventListener('click', (event) => {
    if (event.target.classList.contains('suggestion_command')) {
        const suggestionText = event.target.textContent.trim();
        chatInputEl.value = suggestionText;
        suggestionContainerEl.classList.remove('visible');
        chatInputEl.focus();
    }
});


function startDrag(event) {
    isChatDragging = true;
    offset = {
        x: event.clientX,
        y: event.clientY
    };

    document.addEventListener('mousemove', dragChat);
    document.addEventListener('mouseup', stopDrag);
}

function dragChat(event) {
    if (isChatDragging) {
        const chatContainer = document.querySelector('.chat');
        const chatContainerSize = document.querySelector('.chat-container').getBoundingClientRect();
        
        /* This is extremely janky, but I can't be arsed to do in another way */
        const newChatLeft = Math.max(-30, Math.min(window.innerWidth - chatContainerSize.width * 1.05, event.clientX - offset.x + chatContainer.offsetLeft)) + 'px';
        const newChatTop = Math.min(chatContainerSize.height * 0.925, Math.max(-(chatContainerSize.height * 1.05), event.clientY - offset.y + chatContainer.offsetTop)) + 'px';

        chatContainer.style.left = newChatLeft;
        chatContainer.style.top = newChatTop;

        offset = {
            x: event.clientX,
            y: event.clientY
        };
    }
}

function stopDrag() {
    if (isChatDragging) {
        document.removeEventListener('mousemove', dragChat);
        document.removeEventListener('mouseup', stopDrag);
        isChatDragging = false;
    }
}

let chatMessages = document.getElementById('chat-messages');
let messageIndex = -1;
let messageHistory = [];

document.addEventListener('keydown', (event) => {
    if (event.key === 'ArrowUp') {
        if (messageIndex === -1) {
            messageIndex = messageHistory.length - 1;
            chatInputEl.value = messageHistory[messageIndex];
        } else if (messageIndex > 0) {
            messageIndex--;
            chatInputEl.value = messageHistory[messageIndex];
        }
    } else if (event.key === 'ArrowDown') {
        if (messageIndex < messageHistory.length - 1) {
            messageIndex++;
            chatInputEl.value = messageHistory[messageIndex];
        } else {
            chatInputEl.value = '';
            messageIndex = -1;
        }
    }
});


function appendMessageToHistory(message) {
    messageHistory.push(message);
    if (messageHistory.length > 10) {
        messageHistory.shift();
    }
}

const chatForm = document.getElementById('chat-form');
chatForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const messageText = chatInputEl.value.trim();
    if (messageText !== '') {
        appendMessageToHistory(messageText);
    }
});


// const chatMessages = document.getElementById('chat-messages');
// const messageElement = createMessageElement('ENT510', 'text', 1, 'ambulance', 'black', 'globe');

// chatMessages.appendChild(messageElement);
